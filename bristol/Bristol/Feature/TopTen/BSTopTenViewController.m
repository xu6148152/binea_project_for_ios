//
//  BSTopTenViewController.m
//  Bristol
//
//  Created by Bo on 3/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenViewController.h"
#import "BSTopOneCollectionViewCell.h"
#import "BSTopTenCollectionViewCell.h"
#import "BSTopTenWeekCollectionCell.h"

#import "BSAvatarButton.h"
#import "BSAttributedLabel.h"
#import "BSTopTenPickerRowView.h"
#import "BSTopTenHelpMeTopView.h"
#import "BSShareRankHighlightCollectionViewCell.h"
#import "BSAddSportsViewController.h"
#import "UILabel+DynamicFontSize.h"

#import "BSDataManager.h"
#import "BSSportMO.h"
#import "BSTopDataModel.h"
#import "BSHighlightMO.h"
#import "BSUserMO.h"
#import "BSSportMO.h"
#import "BSTopRankDataModel.h"
#import "BSTopTenWeekDataModel.h"

#import "BSTopTenFriendsHttpRequest.h"
#import "BSTopTenFollowedEventsHttpRequest.h"
#import "BSTopTenSportHttpRequest.h"
#import "BSTopTenHelpMeTopHttpRequest.h"
#import "BSUserEventsHttpRequest.h"

#import "BSEventTracker.h"

@interface BSTopTenViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BSShareRankHighlightCollectionViewCellDelegate>
{
    BSUserMO *_currentUser;
    NSArray *_highlightAry;
    NSArray *_highlightRankAry;
    NSArray *_channelAry;
    NSMutableArray *_currentEventAry;
    long long _totalHighlightNum;
    NSMutableArray *_weekDataAry;
	NSInteger _selectedRow;
    BSTopTenPickerRowView *_selectedRowView;
    BSToptenChannelType _currentChannelType;
    BSTopTenWeekDataModel *_currentWeekDataModel;
    BSEventMO *_currentEvent;
}
@property (nonatomic, strong) NSArray *eventAry;

@property (weak, nonatomic) IBOutlet UIButton *channelBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *beginEventView;
@property (weak, nonatomic) IBOutlet UIView *channelView;
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *weekCollectionView;
@property (weak, nonatomic) IBOutlet UIPickerView *chanelPickerView;
@property (weak, nonatomic) IBOutlet UILabel *weekLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *channelViewHeightConstraint;

@end

@implementation BSTopTenViewController

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"TopTen" bundle:nil] instantiateViewControllerWithIdentifier:@"BSTopTenViewController"];
}

- (BOOL)hidesBottomBarWhenPushed {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[_channelBtn setTitle:ZPLocalizedString(@"FRIENDS") forState:UIControlStateNormal];
	_weekCollectionView.scrollsToTop = NO;
    _currentUser = [BSDataManager sharedInstance].currentUser;
	_currentChannelType = BSToptenChannelTypeFriends;
    _beginEventView.hidden = YES;
	
	self.eventAry = [BSDataManager sharedInstance].currentUser.events.allObjects;
    _weekDataAry = [NSMutableArray array];
    BSUserEventsHttpRequest *request = [BSUserEventsHttpRequest request];
    request.user_id = _currentUser.identifierValue;
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        self.eventAry = ((BSEventsDataModel *)result.dataModel).events;
	} failedBlock:nil];
	
	NSDate *nowDate = [NSDate date];
	NSDate *firstDay = [self getMondayForWeekOfDate:nowDate];
	[self requestWithChannelType:_currentChannelType ID:0 date:firstDay];
	
	if (![self hidesBottomBarWhenPushed]) {
		[self adjustScrollViewInsets:_weekCollectionView];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_followStateDidChanged:) name:kFollowStateDidChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	
    _channelAry = [BSDataManager sharedInstance].currentUser.sportsSortedByAlphabet;
    
    [self.chanelPickerView reloadAllComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setEventAry:(NSArray *)eventAry {
	if (_eventAry != eventAry) {
		_eventAry = eventAry;
		
		[self _filterEvents];
	}
}

- (void)_filterEvents {
	_currentEventAry = [NSMutableArray array];
	NSDate *firstDay, *lastDay;
	if (_currentWeekDataModel) {
		firstDay = _currentWeekDataModel.thisMonday;
		lastDay = _currentWeekDataModel.thisSunday;
	} else {
		NSDate *nowDate = [NSDate date];
		firstDay = [self getMondayForWeekOfDate:nowDate];
		lastDay = [self getSundayForWeekOfDate:nowDate];
	}
	for (BSEventMO *event in _eventAry) {
		if ([self _isEvent:event validInFirstDay:firstDay lastDay:lastDay]) {
			[_currentEventAry addObject:event];
		}
	}
	[self.chanelPickerView reloadAllComponents];
}

- (BOOL)_isEvent:(BSEventMO *)event validInFirstDay:(NSDate *)firstDay lastDay:(NSDate *)lastDay {
	if (([event.start_time timeIntervalSinceDate:firstDay] >= 0 && [event.start_time timeIntervalSinceDate:lastDay] <= 0)
		|| ([event.end_time timeIntervalSinceDate:firstDay] >= 0 && [event.end_time timeIntervalSinceDate:lastDay] <= 0)
		|| ([event.start_time timeIntervalSinceDate:firstDay] < 0 && [event.end_time timeIntervalSinceDate:lastDay] > 0)) {
		return YES;
	} else {
		return NO;
	}
}

- (void)_followStateDidChanged:(NSNotification *)notification {
	id object = notification.object;
	if ([object isKindOfClass:[BSEventMO class]]) {
		BSEventMO *event = object;
		if (event.is_followingValue) {
            if (![_eventAry containsObject:event]) {
                NSMutableArray *events = [NSMutableArray arrayWithArray:_eventAry];
                [events addObject:event];
                _eventAry = events;
            }
            
            if (![_currentEventAry containsObject:event]) {
                if ([self _isEvent:event validInFirstDay:_currentWeekDataModel.thisMonday lastDay:_currentWeekDataModel.thisSunday]) {
                    [_currentEventAry addObject:event];
                }
            }
            
		} else {
            if ([_eventAry containsObject:event]) {
                NSMutableArray *events = [NSMutableArray arrayWithArray:_eventAry];
                [events removeObject:event];
                _eventAry = events;
            }
            
			if ([_currentEventAry containsObject:event]) {
				[_currentEventAry removeObject:event];
			}
		}
        
		[self.chanelPickerView reloadAllComponents];
        
        [self modifyToFriendChannelType];
	}
}

- (void)requestWithChannelType:(BSToptenChannelType)channelType ID:(long long)identifier date:(NSDate *)date {
    BSTopTenHttpRequest *request = nil;
    switch (channelType) {
        default:
        case BSToptenChannelTypeFriends: {
            request = [BSTopTenFriendsHttpRequest request];
            break;
        }
        case BSToptenChannelTypeSports: {
            request = [BSTopTenSportHttpRequest request];
            request.sport_type = (NSInteger)identifier;
            break;
        }
        case BSToptenChannelTypeEvents: {
            request = [BSTopTenFollowedEventsHttpRequest request];
            request.event_id = identifier;
            break;
        }
    }
    
    request.week = [self convertDateToInteger:date];
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        BOOL isWeekExistInCurrentArray = false;
        int index = 0;
        for (int i = 0; i < _weekDataAry.count; i++) {
            BSTopTenWeekDataModel *weekModel = [_weekDataAry objectAtIndex:i];
            if (weekModel.thisMonday == date) {
                isWeekExistInCurrentArray = YES;
                index = i;
            }
        }
        
        BSTopDataModel *toptenDataModel = result.dataModel;
        BSTopTenWeekDataModel *dataModel = [[BSTopTenWeekDataModel alloc] init];
        dataModel.topModel = toptenDataModel;
        dataModel.channelType = channelType;
        dataModel.thisMonday = date;
        dataModel.thisSunday = [self getSundayForWeekOfDate:date];
        dataModel.lastMonday = [self getLastMondayForWeekOfDate:date];
        dataModel.identifier = identifier;
        
        if (!isWeekExistInCurrentArray) {
            [_weekDataAry addObject:dataModel];
             [self.weekCollectionView reloadData];
        } else {
            BSTopTenWeekDataModel *weekModel = [_weekDataAry objectAtIndex:index];
            if (weekModel.channelType == channelType && weekModel.identifier == identifier && weekModel == nil) {
                [self.weekCollectionView reloadData];
            } else {
                [_weekDataAry replaceObjectAtIndex:index withObject:dataModel];
                [self.weekCollectionView reloadData];
            }
        }
        [self scrollViewDidEndDecelerating:self.weekCollectionView];
    } failedBlock:nil];
}

- (void)requestWhenChangeChannelType:(BSToptenChannelType)channelType ID:(long long)identifier date:(NSDate *)date {
    BSTopTenHttpRequest *request = nil;
    switch (channelType) {
        default:
        case BSToptenChannelTypeFriends: {
            request = [BSTopTenFriendsHttpRequest request];
            break;
        }
        case BSToptenChannelTypeSports: {
            request = [BSTopTenSportHttpRequest request];
            request.sport_type = (NSInteger)identifier;
            break;
        }
        case BSToptenChannelTypeEvents: {
            request = [BSTopTenFollowedEventsHttpRequest request];
            request.event_id = identifier;
            break;
        }
    }
    
    request.week = [self convertDateToInteger:date];
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		[BSEventTracker trackPageView:self];

        BSTopDataModel *toptenDataModel = result.dataModel;
        BSTopTenWeekDataModel *dataModel = [[BSTopTenWeekDataModel alloc] init];
        dataModel.topModel = toptenDataModel;
        dataModel.channelType = channelType;
        dataModel.thisMonday = date;
        dataModel.thisSunday = [self getSundayForWeekOfDate:date];
        dataModel.lastMonday = [self getLastMondayForWeekOfDate:date];
        dataModel.identifier = identifier;
        
        int index = 0;
        for (int i = 0; i < _weekDataAry.count; i ++) {
            BSTopTenWeekDataModel *weekModel = [_weekDataAry objectAtIndex:i];
            if (weekModel.thisMonday == date) {
                _weekDataAry[i] = dataModel;
                index = i;
            }
            else {
                weekModel.channelType = channelType;
                weekModel.identifier = 0;
                weekModel.topModel = nil;
            }
        }
        
        NSMutableArray *aryAfterChannelChanged = [NSMutableArray array];
        for (int i = 0; i <= index; i++) {
            [aryAfterChannelChanged addObject:[_weekDataAry objectAtIndex:i]];
        }
        _weekDataAry = aryAfterChannelChanged;
        
        [self.weekCollectionView reloadData];
        [self scrollViewDidEndDecelerating:self.weekCollectionView];
    } failedBlock:nil];
}

- (IBAction)pickerBtnTapped:(id)sender {
	[BSEventTracker trackTap:@"channel_picker" page:self properties:nil];
    BOOL isOriginHidden = _channelView.hidden;
	[self showChannelView:!isOriginHidden];
	if (isOriginHidden) {
		_selectedRow = [_chanelPickerView selectedRowInComponent:0];
	} else {
        if (_currentChannelType == BSToptenChannelTypeFriends) {
            _selectedRow = 0;
        }
		NSInteger rowAfterSelected = [_chanelPickerView selectedRowInComponent:0];
		
		if (rowAfterSelected != _selectedRow) {
			BSTopTenWeekDataModel *dataModel = nil;
			if (self.weekCollectionView.indexPathsForVisibleItems.count > 0) {
				NSIndexPath *indexPath = [self.weekCollectionView.indexPathsForVisibleItems firstObject];
				dataModel = [_weekDataAry objectAtIndex:indexPath.row];
			}

			if (rowAfterSelected == 0 && dataModel) {
				_currentChannelType = BSToptenChannelTypeFriends;
				[self requestWhenChangeChannelType:BSToptenChannelTypeFriends ID:0 date:dataModel.thisMonday];
			} else {
				if (_selectedRowView.event && dataModel) {
					_currentChannelType = BSToptenChannelTypeEvents;
					[self requestWhenChangeChannelType:BSToptenChannelTypeEvents ID:_selectedRowView.event.identifierValue date:dataModel.thisMonday];
				}else if (_selectedRowView.sport && dataModel) {
					_currentChannelType = BSToptenChannelTypeSports;
					[self requestWhenChangeChannelType:BSToptenChannelTypeSports ID:_selectedRowView.sport.identifierValue date:dataModel.thisMonday];
				}
			}
		}
	}
}

- (void)showChannelView:(BOOL)isHidden {
    CGFloat alpha = 0;
    CGFloat heightConstraint = 0;
	if (isHidden) {
		_channelView.alpha = 1;
		[_topView setBackgroundColor:[UIColor whiteColor]];
		_weekCollectionView.userInteractionEnabled = YES;
		[_pickerBtn setTitle:nil forState:UIControlStateNormal];
		[_pickerBtn setImage:[UIImage imageNamed:@"common_dropdown_icon"] forState:UIControlStateNormal];
	} else {
		[_channelView.superview bringSubviewToFront:_channelView];
		_channelView.alpha = 0;
		_channelView.hidden = NO;
		
		_weekCollectionView.userInteractionEnabled = NO;
		[_topView setBackgroundColor:[UIColor whiteColor]];
		[_pickerBtn setTitle:ZPLocalizedString(@"DONE").uppercaseString forState:UIControlStateNormal];
		[_pickerBtn setImage:[UIImage imageNamed:@"profile_followed_checkmark"] forState:UIControlStateNormal];
		alpha = 1.0f;
		heightConstraint = DeviceMainScreenSize.width;
    }
    _channelViewHeightConstraint.constant = heightConstraint;
    [_channelView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _channelView.alpha = alpha;
        [_channelView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (isHidden) {
            _channelView.hidden = YES;
        }
    }];
}

- (NSDateComponents *)getDateComponentWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:date];
    
    return dateComponent;
}

- (NSDate *)dateAtStartOfDay: (NSDate *)date
{
    NSDateComponents *components = [self getDateComponentWithDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)getMondayForWeekOfDate:(NSDate *)newDate {
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    
    double interval = 0;
    NSDate *beginDate = nil;
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:newDate];
    
    return [self dateAtStartOfDay:beginDate];
}

- (NSDate *)getSundayForWeekOfDate:(NSDate *)newDate {
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    BOOL unitRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:newDate];
    if (unitRange) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        endDate = nil;
    }
    
    return endDate;
}

- (NSInteger)convertDateToInteger:(NSDate *)date {
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateComponents *componnet = [self getDateComponentWithDate:date];
    NSInteger year = componnet.year;
    NSInteger month = componnet.month;
    NSInteger day = componnet.day;
    
    NSString *monthStr, *dayStr;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld", (long)month];
    } else {
        monthStr = [NSString stringWithFormat:@"%ld", (long)month];
    }
    
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld", (long)day];
    } else {
        dayStr = [NSString stringWithFormat:@"%ld", (long)day];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld%@%@0", (long)year, monthStr, dayStr];
    NSInteger dateInteger = [dateStr integerValue];
    
    return dateInteger;
}

#pragma mark - BSShareRankHighlightCollectionViewCellDelegate
- (void)shareRankHighlightCollectionViewCell:(BSShareRankHighlightCollectionViewCell *)cell didTapShareButton:(UIButton *)didTapShareButton {
	BSTopRankDataModel *rankDM = [_currentWeekDataModel.topModel.my_ranks firstObject];
	[BSTopTenHelpMeTopView showWithUser:rankDM.highlight.user sport:_selectedRowView.sport event:_selectedRowView.event highlight:rankDM.highlight currentRank:rankDM.rank toptenChannelType:_currentChannelType actionButtonShare:YES actionButtonCallBack:nil];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_weekDataAry count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSTopTenWeekCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSTopTenWeekCollectionCell" forIndexPath:indexPath];
    BSTopTenWeekDataModel *dataModel = [_weekDataAry objectAtIndex:indexPath.row];
    BSTopDataModel *topDataModel = dataModel.topModel;
    cell.highlightAry = topDataModel.highlights;
    cell.totalHighlightNum = topDataModel.total;
	cell.toptenColletionView.scrollsToTop = NO;
    if (topDataModel.highlights.count == 0) {
        cell.toptenColletionView.hidden = YES;
        cell.nohighlightLbl.hidden = NO;
        
    } else {
        cell.toptenColletionView.hidden = NO;
        cell.nohighlightLbl.hidden = YES;
    }
    
	cell.highlightRankAry = topDataModel.my_ranks;
	[self adjustScrollViewInsets:cell.toptenColletionView];
    [cell.toptenColletionView reloadData];
    
    long long identifier = 0;
    NSDate *lastMonday = dataModel.lastMonday;
    if (_currentChannelType == BSToptenChannelTypeFriends) {
        identifier = 0;
    }
    if (_currentChannelType == BSToptenChannelTypeSports) {
        identifier = _selectedRowView.sport.identifierValue;
    }
    if (_currentChannelType == BSToptenChannelTypeEvents) {
        identifier = _selectedRowView.event.identifierValue;
    }
    
    if (indexPath.row == _weekDataAry.count - 1) {
        [self requestWithChannelType:_currentChannelType ID:identifier date:lastMonday];
    }
    
    if (dataModel.topModel == nil) {
        [self requestWithChannelType:_currentChannelType ID:identifier date:dataModel.thisMonday];
    }
    
    return cell;
}

- (NSDate *)getLastMondayForWeekOfDate:(NSDate *)newDate {
    NSDate *thisMonday = [self getMondayForWeekOfDate:newDate];
    NSDate *lastDateBeforeThisWeek = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:thisMonday];
    return [self getMondayForWeekOfDate:lastDateBeforeThisWeek];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	((BSTopTenWeekCollectionCell *)cell).toptenColletionView.contentOffset = CGPointZero;
	((BSTopTenWeekCollectionCell *)cell).toptenColletionView.scrollsToTop = YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(collectionView.width, collectionView.height);
    return size;
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1 + _currentEventAry.count + _channelAry.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 65;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	BSTopTenPickerRowView *lblView;
	if ([view isKindOfClass:[BSTopTenPickerRowView class]]) {
		lblView = (BSTopTenPickerRowView *)view;
	} else {
		NSArray *viewNibs = [[NSBundle mainBundle] loadNibNamed:@"BSTopTenPickerRowView" owner:self options:nil];
		lblView = [viewNibs firstObject];
	}
    
    NSInteger rowIndex = _currentEventAry.count + 1;
    
    if (row == 0) {
        [lblView.channelLbl setText:ZPLocalizedString(@"FRIENDS").uppercaseString];
    } else if (row <= _currentEventAry.count){
        BSEventMO *eventDataModel  = [_currentEventAry objectAtIndex:(row - 1)];
        [lblView configWithEvent:eventDataModel];
    } else if (_channelAry.count > 0){
        BSSportMO *sportDataModel = [_channelAry objectAtIndex:(row - rowIndex)];
        [lblView configWithSport:sportDataModel];
    }
    
    return lblView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    BSTopTenPickerRowView *view = (BSTopTenPickerRowView *)[pickerView viewForRow:row forComponent:component];
    NSString *channelStr = view.channelLbl.text;
    [_channelBtn setTitle:channelStr.uppercaseString forState:UIControlStateNormal];
    NSString *channelBtnImg;
    if (view.event) {
        channelBtnImg = @"profile_location_icon";
    } else if (view.sport){
        channelBtnImg = nil;
    } else {
        channelBtnImg = @"common_header_people_icon";
    }
    [_channelBtn setImage:[UIImage imageNamed:channelBtnImg] forState:UIControlStateNormal];
	
    _selectedRowView = view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = self.weekCollectionView.contentOffset.x / DeviceMainScreenSize.width;
    if (index < _weekDataAry.count) {
        _currentWeekDataModel = [_weekDataAry objectAtIndex:index];
        NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
        [dataFormatter setDateFormat:@"MMM.dd"];
        NSString *beginStr = [dataFormatter stringFromDate:_currentWeekDataModel.thisMonday];
        NSString *endStr = [dataFormatter stringFromDate:_currentWeekDataModel.thisSunday];
        NSString *weekStr = [NSString stringWithFormat:@"%@-%@", beginStr, endStr];
        if (index == 0) {
            weekStr = ZPLocalizedString(@"THIS WEEK");
        } else if (index == 1) {
            weekStr = ZPLocalizedString(@"LAST WEEK");
        }
        
        [self.weekLbl setText:weekStr];
    
        if (index == _weekDataAry.count - 1) {
            return;
        }
		
		[self _filterEvents];
      
        [self modifyToFriendChannelType];
    }
}

- (void)modifyToFriendChannelType {
    if (_currentChannelType == BSToptenChannelTypeEvents) {
        _currentEvent = _selectedRowView.event;
        if (!_currentEvent) {
            return;
        }
        
        BOOL isEventValidInCurrentWeek = [self _isEvent:_currentEvent validInFirstDay:_currentWeekDataModel.thisMonday lastDay:_currentWeekDataModel.thisSunday];
        if (!isEventValidInCurrentWeek || !_currentEvent.is_followingValue) {
            [_channelBtn setTitle:ZPLocalizedString(@"FRIENDS") forState:UIControlStateNormal];
            [_channelBtn setImage:[UIImage imageNamed:@"common_header_people_icon"] forState:UIControlStateNormal];
            _selectedRow = 0;
            _currentChannelType = BSToptenChannelTypeFriends;
            _currentEvent = nil;
            [self requestWhenChangeChannelType:BSToptenChannelTypeFriends ID:0 date:_currentWeekDataModel.thisMonday];
        }
    }
}

#pragma mark - event tracking
- (NSString *) useCase {
	switch (_currentChannelType) {
		case BSToptenChannelTypeSports:
			return _selectedRowView.sport.nameLocalized;
		case BSToptenChannelTypeEvents:
			return _selectedRowView.event.name;
		case BSToptenChannelTypeFriends:
		default:
			return @"friends";
	}
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowAddSportsView"]) {
		((BSAddSportsViewController *)segue.destinationViewController).useCase = @"top10";
	}
}
@end
