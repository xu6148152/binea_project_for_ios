//
//  BSFeedViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedViewController.h"
#import "BSUsersViewController.h"
#import "BSProfileViewController.h"
#import "BSFeedCommentsViewController.h"
#import "BSCaptureViewController.h"
#import "BSAccountLoginViewController.h"
#import "BSAddSportsViewController.h"
#import "BSCaptureViewController.h"
#import "BSProfileFindFollowPeopleViewController.h"
#import "BSProfileEditViewController.h"

#import "BSFeedHighlightTableViewCell.h"
#import "BSFeedAuthorTableViewCell.h"
#import "BSFeedSectionHeaderTableViewCell.h"
#import "BSFeedCommentTableViewCell.h"
#import "BSFeedSeeAllCommentsTableViewCell.h"
#import "BSFeedActionTableViewCell.h"
#import "BSFeedRecommendTableViewCell.h"
#import "BSFeedUploadingTableViewCell.h"
#import "BSLoadMoreTableViewCell.h"
#import "BSFeedPopUpView.h"
#import "BSTopTenHelpMeTopView.h"

#import "BSEventTracker.h"
#import "BSDataManager.h"
#import "BSLoadMoreType.h"
#import "BSFeedTimelineHttpRequest.h"
#import "BSFeedCheckHttpRequest.h"
#import "BSHighlightReportHttpRequest.h"
#import "BSHighlightDeleteHttpRequest.h"
#import "BSUserInfoWithUsernameHttpRequest.h"

#import "SDWebImageManager.h"
#import "CWStatusBarNotification.h"
#import "INTULocationManager.h"

typedef NS_ENUM(NSUInteger, BSFeedPopUpViewModel)
{
    BSFeedPopUpViewModel_Sports,
    BSFeedPopUpViewModel_Friends,
    BSFeedPopUpViewModel_Capture,
    BSFeedPopUpViewModel_Team
};

typedef NS_ENUM (NSUInteger, BSPopUpActionType) {
    BSPopUpActionType_Close,
    BSPopUpActionType_Other
};

#define kNewFeedsCheckingPeriodWithSeconds (60)

@interface BSFeedViewController () <BSFeedCommentTableViewCellDelegate, BSFeedUploadingTableViewCellDelegate, BSFeedAuthorTableViewCellDelegate, BSRecommendTableViewCellDelegate, TTTAttributedLabelDelegate, BSFeedPopUpViewDelegate>
{
	NSMutableArray *_aryFeeds;
    NSMutableArray *_aryFeedsRecommended;
	NSMutableArray *_aryFeedsToPost;
	NSMutableArray *_visibleFeedHighlightTableViewCells;
	UIRefreshControl *_refreshControl;
	CLLocation *_currentLocation;
	BSLoadMoreTableViewCell *_loadMoreTableViewCell;
	BSFeedTimelineHttpRequest *_feedOlderHttpRequest;
	DataModelIdType _lastHighlightId;
    BOOL _isSingleFeed, _isNoMoreData, _showCreateTeamNotification, _canShowNewFeedsNotification;
    BSFeedPopUpView *_popUpView;
    BSFeedPopUpViewModel _feedPopUpViewModel;
}

@property (nonatomic, strong) BSHighlightMO *highlight;
@property (nonatomic, strong) BSNotificationMO *notification;
@property (nonatomic, strong) CWStatusBarNotification *statusBarNotification;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;

@end

#define kTableViewCellActionHeight 70
#define kOneDayDurationTime 60*60*24
#define kPopUpViewHeight 127

@implementation BSFeedViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Feed" bundle:nil] instantiateViewControllerWithIdentifier:@"BSFeedViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Feed" bundle:nil] instantiateViewControllerWithIdentifier:@"BSFeedViewControllerNav"];
}

+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight notification:(BSNotificationMO *)notification {
	BSFeedViewController *vc = [self instanceFromStoryboard];
	vc.highlight = highlight;
	vc.notification = notification;
	
	return vc;
}

+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight {
	return [BSFeedViewController instanceWithHighlight:highlight notification:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_visibleFeedHighlightTableViewCells = [NSMutableArray array];
    _isSingleFeed = _highlight ? YES : NO;
	if (_isSingleFeed) {
		self.title = ZPLocalizedString(@"Highlight");

		_aryFeeds = [@[_highlight] mutableCopy];
	} else {
		_refreshControl = [[UIRefreshControl alloc] init];
		[_refreshControl addTarget:self action:@selector(_refreshFeedsManually) forControlEvents:UIControlEventValueChanged];
		[self.tableView addSubview:_refreshControl];
		
		_tableViewTopLayoutConstraint.constant = 20;
		self.automaticallyAdjustsScrollViewInsets = NO;
		
		_aryFeeds = [[[BSDataManager sharedInstance] getCachedFeedHighlights] mutableCopy];
		BSHighlightMO *highlight = [_aryFeeds lastObject];
		_lastHighlightId = highlight.identifierValue;
		
		[self _pulldownRefreshFeeds];
	}
	[self _checkIfCanStartCheckingNewFeedsWithDelay:kNewFeedsCheckingPeriodWithSeconds];
	[self _requestLocation];
	[self.tableView registerNib:[UINib nibWithNibName:BSLoadMoreTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLoadMoreTableViewCell.className];
	[self.tableView registerNib:[UINib nibWithNibName:BSFeedSectionHeaderTableViewCell.className bundle:nil] forHeaderFooterViewReuseIdentifier:BSFeedSectionHeaderTableViewCell.className];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidLogin) name:kUserDidLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidLogout) name:kUserDidLogoutNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_eventOrTeamProfileDidShown:) name:kEventProfileDidShownNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_eventOrTeamProfileDidShown:) name:kTeamProfileDidShownNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightDidPosted:) name:kHighlightDidPostedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightDidEnqueueToPost:) name:kHighlightDidEnqueueToPostNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_tableViewReloadData) name:kCommentDidPostedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (BSUserMO *)_getCurrentUser {
    return [BSDataManager sharedInstance].currentUser;
}

- (void)_setPopUpViews {
	if (_isSingleFeed) {
		return;
	}
	
    BSUserMO *currentUser = [self _getCurrentUser];
    NSDate *currentDate = [NSDate date];
    NSDate *firstLoginDate = [BSUtility getPopUpFirstActionDate:kFirstLoginDate];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:firstLoginDate];
    
    NSString *title = [NSString stringWithFormat:@"%@, %@", ZPLocalizedString(@"Welcome"), currentUser.name_id];
    BOOL isPopUpViewExist = NO;
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[BSFeedPopUpView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (interval < kOneDayDurationTime) {
        NSDate *firstAddSportsDate = [BSUtility getPopUpFirstActionDate:kFirstAddSportsDate];
        if (firstAddSportsDate == nil && currentUser.sports.count == 0) {
            [self showPopUpViewWithTitle:title content:ZPLocalizedString(@"Feel like to see the most exited highlights in your feed? let’s pick your") attributeContent:ZPLocalizedString(@"FAVOURITE SPORTS").uppercaseString btnImgName:@"common_popup_favsport" isDownArrowImgHidden:YES];
            isPopUpViewExist = YES;
            _feedPopUpViewModel = BSFeedPopUpViewModel_Sports;
        }
    } else if (interval >= kOneDayDurationTime && interval < kOneDayDurationTime * 3) {
        NSDate *firstAddFriendsDate = [BSUtility getPopUpFirstActionDate:kFirstAddFriendsDate];
        if (firstAddFriendsDate == nil) {
            [self showPopUpViewWithTitle:title content:ZPLocalizedString(@"Let’s make this more exciting by connecting with people you know.") attributeContent:ZPLocalizedString(@"ADD FRIENDS").uppercaseString btnImgName:@"common_popup_addfriend" isDownArrowImgHidden:YES];
            _feedPopUpViewModel = BSFeedPopUpViewModel_Friends;
            isPopUpViewExist = YES;
        }
    } else if (interval >= kOneDayDurationTime * 3) {
        NSDate *firstTimeCaptureDate = [BSUtility getPopUpFirstActionDate:kFirstCaptureDate];
        if (firstTimeCaptureDate == nil) {
            [self showPopUpViewWithTitle:ZPLocalizedString(@"Your first highlight") content:ZPLocalizedString(@"Remember your best moment.") attributeContent:ZPLocalizedString(@"CAPTURE NOW").uppercaseString btnImgName:@"common_popup_capturehighlight" isDownArrowImgHidden:NO];
            _feedPopUpViewModel = BSFeedPopUpViewModel_Capture;
            isPopUpViewExist = YES;
        }
    }
    
    if (!isPopUpViewExist && [BSUtility getPopUpFirstActionDate:kFirstCreateTeamDate] == nil && _showCreateTeamNotification) {
        [self showPopUpViewWithTitle:ZPLocalizedString(@"Power in number") content:ZPLocalizedString(@"Build or register your team to start sharing best highlights.") attributeContent:ZPLocalizedString(@"CREATE A TEAM") btnImgName:@"common_popup_createteam" isDownArrowImgHidden:YES];
        _feedPopUpViewModel = BSFeedPopUpViewModel_Team;
        isPopUpViewExist = YES;
    }
	
	if (isPopUpViewExist) {
		[BSEventTracker trackGuideView:[self guideName] page:self];
	}
}

- (void)showPopUpViewWithTitle:(NSString *)title content:(NSString *)content attributeContent:(NSString *)attributeContent btnImgName:(NSString *)btnImgName isDownArrowImgHidden:(BOOL)isHidden{
    NSArray *viewNibs = [[NSBundle mainBundle] loadNibNamed:@"BSFeedPopUpView" owner:self options:nil];
    _popUpView = [viewNibs firstObject];
    _popUpView.frame = CGRectMake(0, self.view.bounds.size.height - self.tabBarController.tabBar.height - kPopUpViewHeight, self.view.width, kPopUpViewHeight);
    [_popUpView configWithTitle:title content:content attributeContent:attributeContent btnImgName:btnImgName isDownArrowImgHidden:isHidden];
    _popUpView.delegate = self;
    [self.tabBarController.view addSubview:_popUpView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    if (_popUpView.hidden) {
        _popUpView.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self scrollViewDidScroll:self.tableView]; // play video
    if ([self _getCurrentUser] && !_highlight) {
        [self _setPopUpViews];
    }
	
	if (_notification && !_notification.local_has_readValue) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			_notification.local_has_readValue = YES;
			[BSTopTenHelpMeTopView showWithUser:_notification.highlight.user sport:_notification.sport event:_notification.event highlight:_notification.highlight currentRank:_notification.current_rankValue toptenChannelType:_notification.list_typeValue actionButtonShare:NO actionButtonCallBack:nil];
		});
	}
	
	[self _checkIfCanShowNewFeedsNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[self _setVisibleVideoPlay:NO];
    if (_popUpView) {
        _popUpView.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.tableView.separatorInset = UIEdgeInsetsMake(0, 28, 0, 0);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_popUpView removeFromSuperview];
	self.tableView.dataSource = nil;
	self.tableView.delegate = nil;
}

- (void)_clearFeedsLocalIndex {
	for (BSHighlightMO *highlight in _aryFeeds) {
		highlight.local_index_in_feedValue = NSUIntegerMax;
	}
}

- (void)_resetFeedsLocalIndex {
	uint index = 0;
	for (BSHighlightMO *highlight in _aryFeeds) {
		highlight.local_index_in_feedValue = index++;
	}
}

- (void)_refreshFeedsManually {
	[BSEventTracker trackAction:@"feed_pull_to_refresh" page:self properties:nil];
	[self _refreshFeeds];
}

- (void)_refreshFeeds {
	BSFeedTimelineHttpRequest *request = [BSFeedTimelineHttpRequest request];
	request.olderThanHighlightId = -1;
	request.startIndex = 0;
    request.show_create_team_notification = YES;
	if (_currentLocation) {
		request.latitude = _currentLocation.coordinate.latitude;
		request.longitude = _currentLocation.coordinate.longitude;
	}
	NSUInteger countInOnePage = request.countInOnePage;
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		BSFeedDataModel *dataModel = (BSFeedDataModel *)result.dataModel;
		_lastHighlightId = dataModel.last_highlight;
		_isNoMoreData = dataModel.highlights.count < countInOnePage;
		[self _clearFeedsLocalIndex];
		[_aryFeeds removeAllObjects];
		[_aryFeeds addObjectsFromArray:dataModel.highlights];
		[self _resetFeedsLocalIndex];
		
		NSArray *recomendEvents = dataModel.recomendEvents ?: dataModel.recomendTeams;
		BSEventMO *eventOrTeam = [recomendEvents firstObject];
		NSArray *notifications = dataModel.notifications;
		BSNotificationMO *createTeamNotification = [notifications firstObject];
		if ([createTeamNotification.create_team_notification_type isEqualToString:@"create_team"]) {
			_showCreateTeamNotification = YES;
			[self _setPopUpViews];
		}
		if (eventOrTeam) {
			NSURL *coverUrl = [NSURL URLWithString:eventOrTeam.cover_url];
			ZPVoidBlock coverImageIsReady = ^ {
				[BSEventTracker trackGuideView:([eventOrTeam isKindOfClass:[BSEventMO class]] ? @"recommend_event":@"recommend_team") page:self];
				_aryFeedsRecommended = [NSMutableArray arrayWithArray:recomendEvents];
				[self.tableView reloadData];
			};
			if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:coverUrl]) {
				//download first
				[[SDWebImageManager sharedManager] downloadImageWithURL:coverUrl options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
					coverImageIsReady();
				}];
			} else {
				coverImageIsReady();
			}
			
			NSURL *avatarUrl = [NSURL URLWithString:eventOrTeam.avatar_url];
			if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:avatarUrl]) {
				[[SDWebImageManager sharedManager] downloadImageWithURL:avatarUrl options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
					
				}];
			}
		}
		
		[self.tableView reloadData];
		
		[_refreshControl endRefreshing];
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		[_refreshControl endRefreshing];
	}];
}

- (void)_pulldownRefreshFeeds {
	[_refreshControl beginRefreshing];
	[self.tableView setContentOffset:CGPointMake(0, -_refreshControl.height - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES];

    NSDate *currentDate = [NSDate date];
    NSDate *firstLoginDate = [BSUtility getPopUpFirstActionDate:kFirstLoginDate];
    if (firstLoginDate == nil) {
        [BSUtility savePopUpFirstActionDate:currentDate withKey:kFirstLoginDate];
    }
    
	[self _refreshFeeds];
}

- (void)_loadMoreFeeds {
	if (!_feedOlderHttpRequest) {
		[BSEventTracker trackAction:@"load_more_videos" page:self properties:nil];

		_loadMoreTableViewCell.loadMoreType = BSLoadMoreTypeLoading;
		
		_feedOlderHttpRequest = [BSFeedTimelineHttpRequest request];
		_feedOlderHttpRequest.olderThanHighlightId = _lastHighlightId;
		_feedOlderHttpRequest.startIndex = _aryFeeds.count;
		if (_currentLocation) {
			_feedOlderHttpRequest.latitude = _currentLocation.coordinate.latitude;
			_feedOlderHttpRequest.longitude = _currentLocation.coordinate.longitude;
		}
		[_feedOlderHttpRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			BSFeedDataModel *dataModel = (BSFeedDataModel *)result.dataModel;
			_lastHighlightId = dataModel.last_highlight;
			_isNoMoreData = dataModel.highlights.count == 0;
			
			if (_isNoMoreData) {
				_loadMoreTableViewCell.loadMoreType = BSLoadMoreTypeNoMore;
			} else {
				[_aryFeeds addObjectsFromArray:dataModel.highlights];
				[self _resetFeedsLocalIndex];
				[self.tableView reloadData];
			}
			
			_feedOlderHttpRequest = nil;
		} failedBlock:^(BSHttpResponseDataModel *result) {
			_loadMoreTableViewCell.loadMoreType = BSLoadMoreTypeFaild;
			_loadMoreTableViewCell.lblFaild.text = result.error.localizedDescription;
			
			_feedOlderHttpRequest = nil;
		}];
	}
}

- (void)_popUpDidTapAction:(BSPopUpActionType)popUpActionType {
    BSUserMO *currentUser = [self _getCurrentUser];;
    NSDate *currentDate = [NSDate date];
    NSString *firstActionDateKey;
    
    if (_feedPopUpViewModel == BSFeedPopUpViewModel_Sports) {
        if (popUpActionType == BSPopUpActionType_Other) {
            BSAddSportsViewController *vc = [BSAddSportsViewController instanceFromStoryboardWithUser:currentUser];
			vc.useCase = @"welcome";
            [self.navigationController pushViewController:vc animated:YES];
        }
        firstActionDateKey = kFirstAddSportsDate;
    }
    if (_feedPopUpViewModel == BSFeedPopUpViewModel_Friends) {
        if (popUpActionType == BSPopUpActionType_Other) {
            BSProfileFindFollowPeopleViewController *vc = [BSProfileFindFollowPeopleViewController instanceFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
        firstActionDateKey = kFirstAddFriendsDate;
    }
    if (_feedPopUpViewModel == BSFeedPopUpViewModel_Capture) {
        if (popUpActionType == BSPopUpActionType_Other) {
            BSCaptureViewController *vc = [BSCaptureViewController instanceFromStoryboard];
            [self presentViewController:vc animated:YES completion:NULL];
        }
        firstActionDateKey = kFirstCaptureDate;
    }
    if (_feedPopUpViewModel == BSFeedPopUpViewModel_Team) {
        if (popUpActionType == BSPopUpActionType_Other) {
            UINavigationController *Nav = [BSProfileEditViewController instanceNavigationControllerFromStoryboard];
            BSProfileEditViewController *vc = (BSProfileEditViewController *)Nav.rootViewController;
            vc.dataType = BSProfileEditDataTypeTeamCreate;
            [self presentViewController:Nav animated:YES completion:NULL];
        }
        firstActionDateKey = kFirstCreateTeamDate;
    }
    
    [BSUtility savePopUpFirstActionDate:currentDate withKey:firstActionDateKey];
    [self _removePopUpView];
}

- (void)_removePopUpView {
    [_popUpView removeFromSuperview];
    _popUpView = nil;
}

- (void)_requestLocation {
	[[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
		if (status == INTULocationStatusSuccess) {
			_currentLocation = currentLocation;
		}
	}];
}

#pragma mark - new feeds notification
- (CWStatusBarNotification *)statusBarNotification {
	if (!_statusBarNotification) {
		__weak typeof(self) weakSelf = self;
		_statusBarNotification = [CWStatusBarNotification new];
		_statusBarNotification.notificationAnimationInStyle = CWNotificationAnimationStyleBottom;
		_statusBarNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
		_statusBarNotification.notificationStyle = CWNotificationStyleStatusBarNotification;
		_statusBarNotification.notificationTappedBlock = ^ {
			[weakSelf _pulldownRefreshFeeds];
		};
	}
	return _statusBarNotification;
}

- (void)_actuallyCheckingNewFeeds {
	BSHighlightMO *highlight = [_aryFeeds firstObject];
	if (highlight) {
		BSFeedCheckHttpRequest *request = [BSFeedCheckHttpRequest request];
		request.lastHighlightId = highlight.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			BSNewFeedDataModel *dm = result.dataModel;
			if (dm.newFeedsCount > 0) {
				_canShowNewFeedsNotification = YES;
				[self _checkIfCanShowNewFeedsNotification];
			}
			
			[self performSelector:@selector(_actuallyCheckingNewFeeds) withObject:nil afterDelay:kNewFeedsCheckingPeriodWithSeconds];
		} failedBlock:nil];
	}
}

- (void)_checkIfCanStartCheckingNewFeedsWithDelay:(NSUInteger)delay {
	if (!_isSingleFeed) {
		[self performSelector:@selector(_actuallyCheckingNewFeeds) withObject:nil afterDelay:delay];
	}
}

- (void)_stopCheckingNewFeeds {
	if (!_isSingleFeed) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_actuallyCheckingNewFeeds) object:nil];
	}
}

- (void)_checkIfCanShowNewFeedsNotification {
	if (_canShowNewFeedsNotification && self.view.window) {
		UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"BSNewFeed" owner:nil options:nil] firstObject];
		[self.statusBarNotification displayNotificationWithView:view forDuration:3];
		_canShowNewFeedsNotification = NO;
	}
}

#pragma mark - notifications
- (void)_userDidLogin {
	[self _pulldownRefreshFeeds];
}

- (void)_userDidLogout {
	[self _stopCheckingNewFeeds];
}

- (void)_eventOrTeamProfileDidShown:(NSNotification *)notification {
	BSEventMO *eventOrTeam = notification.object;
	if ([_aryFeedsRecommended containsObject:eventOrTeam]) {
		[_aryFeedsRecommended removeObject:eventOrTeam];
		[self _tableViewReloadData];
	}
}

- (void)_highlightDidPosted:(NSNotification *)notification {
	BSHighlightMO *highlightRemote = notification.object;
	[_aryFeeds insertObject:highlightRemote atIndex:0];
	[self _resetFeedsLocalIndex];
	[self.tableView reloadData];
		
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSUInteger index = NSNotFound;
		BSHighlightMO *highlightLocal = nil;
		for (BSHighlightMO *highlight in _aryFeedsToPost) {
			if (highlight.identifierValue == highlightRemote.identifierValue) {
				index = [_aryFeedsToPost indexOfObject:highlight];
				highlightLocal = highlight;
				break;
			}
		}
		
		[_aryFeedsToPost removeObject:highlightLocal];
		[highlightLocal deleteEntity];
		if (index == NSNotFound) {
			[self.tableView reloadData];
		} else {
			[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		}
	});
}

- (void)_highlightDidEnqueueToPost:(NSNotification *)notification {
	self.tabBarController.selectedIndex = 0;
	[self.tableView reloadData];
	self.tableView.contentOffset = CGPointMake(0, 0);
}

- (void)_tableViewReloadData {
	[self.tableView reloadData];
}

- (void)_applicationWillEnterForeground {
	[self _checkIfCanStartCheckingNewFeedsWithDelay:0];
}

- (void)_applicationDidEnterBackground {
	[self _stopCheckingNewFeeds];
}

#pragma mark - BSFeedAuthorTableViewCellDelegate
- (void)feedAuthorTableViewCell:(BSFeedAuthorTableViewCell *)feedAuthorCell willTapShareButton:(UIButton *)button {
	[self _setVisibleVideoPlay:NO];
}

- (void)feedAuthorTableViewCell:(BSFeedAuthorTableViewCell *)feedAuthorCell didTapActionButton:(UIButton *)button {
	[self _setVisibleVideoPlay:NO];
	
	BSHighlightMO *highlight = feedAuthorCell.highlight;
	[BSUIGlobal showActionSheetTitle:nil isDestructive:NO actionTitle:ZPLocalizedString(@"Report Not Relative") actionHandler:^{
		[BSEventTracker trackTap:@"video_report" page:self properties:@{@"video_id":highlight.identifier}];
		BSHighlightReportHttpRequest *request = [BSHighlightReportHttpRequest requestWithHighlightId:highlight.identifierValue];
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSUIGlobal showMessage:ZPLocalizedString(@"Reported")];
		} failedBlock:nil];
	} additionalConstruction:^(BSUIActionSheet *actionSheet) {
		if (highlight.user == [self _getCurrentUser]) {
			[actionSheet addButtonWithTitle:ZPLocalizedString(@"Delete highlight")isDestructive:YES handler: ^{
				[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Delete highlight conform") isDestructive:YES actionTitle:ZPLocalizedString(@"Delete") actionHandler:^{
					[BSEventTracker trackTap:@"video_delete" page:self properties:@{@"video_id":highlight.identifier}];
					BSHighlightDeleteHttpRequest *request = [BSHighlightDeleteHttpRequest request];
					request.highlightId = highlight.identifierValue;
					[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
						[BSUIGlobal hideLoading];
						
						[[BSDataManager sharedInstance] cancelVideoDownloadingForHighlight:highlight];
						[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightDidRemovedNotification object:highlight];
						
						if (_isSingleFeed) {
							[self.navigationController popToRootViewControllerAnimated:YES];
						} else {
							NSInteger index = 1 + _aryFeedsRecommended.count + [_aryFeeds indexOfObject:highlight] * 2;
							[_aryFeeds removeObject:highlight];
							[self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 2)] withRowAnimation:UITableViewRowAnimationFade];
						}
					} failedBlock:nil];
					[BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
				}];
			}];
		}
	}];
}

- (void)_showCommentViewWithPostMode:(BOOL)postMode highlight:(BSHighlightMO *)highlight {
	[self.navigationController pushViewController:[BSFeedCommentsViewController instanceWithHighlight:highlight showKeyboard:postMode] animated:YES];
}

#pragma mark - BSFeedCommentTableViewCellDelegate
- (void)_showProfileForUser:(BSUserMO *)user {
	if (user) {
		[self.navigationController pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:user] animated:YES];
	}
}

- (void)feedCommentCell:(BSFeedCommentTableViewCell *)commentCell didSelectCommenter:(BSUserMO *)commenter {
	// no action
//	[self _showProfileForUser:commenter];
}

- (void)feedCommentCell:(BSFeedCommentTableViewCell *)commentCell didSelectURL:(NSURL *)url {
	
}

- (void)feedCommentCell:(BSFeedCommentTableViewCell *)commentCell didSelectHashtag:(NSString *)hashtag {
	
}

- (void)feedCommentCell:(BSFeedCommentTableViewCell *)commentCell didSelectMention:(NSString *)mention {
	if (mention.length > 0) {
		BSUserInfoWithUsernameHttpRequest *request = [BSUserInfoWithUsernameHttpRequest request];
		request.userName = mention;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[self _showProfileForUser:result.dataModel];
		} failedBlock:nil];
	}
}

#pragma mark - BSRecommendTableViewCellDelegate
- (void)feedRecommendCell:(BSFeedRecommendTableViewCell *)cell didTapCloseButton:(UIButton *)button {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Delete highlight conform") isDestructive:YES actionTitle:ZPLocalizedString(@"Delete") actionHandler:^{
			[_aryFeedsRecommended removeObject:cell.bindingData];
			
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
		}];
	}
}

#pragma mark - BSFeedUploadingTableViewCellDelegate
- (void)feedUploadingCell:(BSFeedUploadingTableViewCell *)cell didTapCloseButton:(UIButton *)button {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		[_aryFeedsToPost removeObject:cell.highlight];
		[cell.highlight deleteEntity];
		
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark - BSFeedPopUpDelegate
- (void)feedPopUpViewDidTapAddButton {
	[BSEventTracker trackTap:@"open_guide" page:self properties:([self guideName] ? @{@"guide":[self guideName]} : nil)];
    [self _popUpDidTapAction:BSPopUpActionType_Other];
}

- (void)feedPopUpViewDidTapAttributeLabel {
	[BSEventTracker trackTap:@"open_guide" page:self properties:([self guideName] ? @{@"guide":[self guideName]} : nil)];
    [self _popUpDidTapAction:BSPopUpActionType_Other];
}

- (void)feedPopUpViewDidTapCloseButton {
	[BSEventTracker trackTap:@"close_guide" page:self properties:([self guideName] ? @{@"guide":[self guideName]} : nil)];
    [UIView animateWithDuration:kDefaultAnimateDuration animations:^{
        [self.tabBarController.view insertSubview:_popUpView belowSubview:self.tabBarController.tabBar];
         _popUpView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.width, kPopUpViewHeight);
    } completion:^(BOOL finished) {
        [self _popUpDidTapAction:BSPopUpActionType_Close];
    }];
}

#pragma mark - UITableViewDataSource
- (NSUInteger)_getCommentsCountForHighlight:(BSHighlightMO *)highlight {
	NSInteger commentsCount = highlight.comments_countValue;
	if (commentsCount >= 3) {
		commentsCount = 4;
		highlight.showSeeAllCommentsCell = YES;
	} else {
		highlight.showSeeAllCommentsCell = NO;
	}
	
	return commentsCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSUInteger count = _aryFeeds.count * 2;
	if (!_isSingleFeed) {
		count += (1 + _aryFeedsRecommended.count + 1); // uploading, recommend, feeds, load more
		_aryFeedsToPost = [[[BSDataManager sharedInstance] getLocalHighlightsForPost] mutableCopy];
	}
	
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_isSingleFeed) {
		if (section == 0) {
			return 1;
		} else {
			return 1 + [self _getCommentsCountForHighlight:_highlight] + 1;
		}
	} else {
		if (section == 0) {
			return _aryFeedsToPost.count;
		} else if (section < _aryFeedsRecommended.count + 1) {
			return 1;
		} else if (section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			return 1;// load more
		} else {
			NSInteger sectionHighlight = section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				return 1;
			} else {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				return 1 + [self _getCommentsCountForHighlight:highlight] + 1;
			}
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (_isSingleFeed) {
		if (section == 0) {
			return 60;
		} else {
			return 0;
		}
	} else {
		if (section == 0) {
			return 0;
		} else if (section < _aryFeedsRecommended.count + 1) {
			return 0;
		} else if (section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			return 0;// load more
		} else {
			NSInteger sectionHighlight = section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				return 60;
			} else {
				return 0;
			}
		}
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (_isSingleFeed) {
		if (section == 0) {
			BSFeedSectionHeaderTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BSFeedSectionHeaderTableViewCell.className];
			[cell configWithHighlight:_highlight];
			
			return cell;
		} else {
			return nil;
		}
	} else {
		if (section == 0) {
			return nil;
		} else if (section < _aryFeedsRecommended.count + 1) {
			return nil;
		} else if (section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			return nil;// load more
		} else {
			NSInteger sectionHighlight = section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				
				BSFeedSectionHeaderTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BSFeedSectionHeaderTableViewCell.className];
				[cell configWithHighlight:highlight];
				
				return cell;
			} else {
				return nil;
			}
		}
	}
}

- (UITableViewCell *)_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath highlight:(BSHighlightMO *)highlight {
	if (indexPath.row == 0) {
		BSFeedAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedAuthorTableViewCell.className];
		cell.delegate = self;
		[cell configWithHighlight:highlight];
		
		return cell;
	} else if (indexPath.row == [self _getCommentsCountForHighlight:highlight] + 1) {
		BSFeedActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedActionTableViewCell.className];
		[cell configWithHighlight:highlight];
		
		return cell;
	} else {
		if (indexPath.row == 1 && highlight.showSeeAllCommentsCell) {
			BSFeedSeeAllCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedSeeAllCommentsTableViewCell.className];
			[cell configWithCommentsCount:highlight.comments_countValue];
			
			return cell;
		} else {
			BSFeedCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedCommentTableViewCell.className];
			NSArray *aryComments = highlight.commentsSortedByCreate_AtAsc;
			NSInteger index = indexPath.row - (highlight.showSeeAllCommentsCell ? 2 : 1);
			[cell configWithDataModel:aryComments[index] showCommenter:YES];
			cell.delegate = self;
			
			return cell;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_isSingleFeed) {
		if (indexPath.section == 0) {
			BSFeedHighlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedHighlightTableViewCell.className];
			[cell configWithHighlight:_highlight];
			
			return cell;
		} else {
			return [self _tableView:tableView cellForRowAtIndexPath:indexPath highlight:_highlight];
		}
	} else {
		if (indexPath.section == 0) {
			BSFeedUploadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedUploadingTableViewCell.className];
			cell.delegate = self;
			[cell configWithHighlight:_aryFeedsToPost[indexPath.row]];
			
			return cell;
		} else if (indexPath.section < _aryFeedsRecommended.count + 1) {
			BSFeedRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedRecommendTableViewCell.className];
			cell.delegate = self;
			[cell configWithDataModel:_aryFeedsRecommended[indexPath.section - 1]];
			
			return cell;
		} else if (indexPath.section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			_loadMoreTableViewCell = [tableView dequeueReusableCellWithIdentifier:BSLoadMoreTableViewCell.className forIndexPath:indexPath];
			[_loadMoreTableViewCell.btnRetry addTarget:self action:@selector(_loadMoreFeeds) forControlEvents:UIControlEventTouchUpInside];
			if (!_isSingleFeed && _aryFeeds.count == 0) {
				_loadMoreTableViewCell.hidden = YES;
			} else {
				_loadMoreTableViewCell.hidden = NO;
			}
			
			return _loadMoreTableViewCell;
		} else {
			NSInteger sectionHighlight = indexPath.section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				
				BSFeedHighlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSFeedHighlightTableViewCell.className];
				[cell configWithHighlight:highlight];
				
				return cell;
			} else {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				
				return [self _tableView:tableView cellForRowAtIndexPath:indexPath highlight:highlight];
			}
		}
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell isKindOfClass:[BSLoadMoreTableViewCell class]]) {
		if (!_isNoMoreData) {
			[self _loadMoreFeeds];
		}
	} else if ([cell isKindOfClass:[BSFeedHighlightTableViewCell class]]) {
		if (![_visibleFeedHighlightTableViewCells containsObject:cell]) {
			[_visibleFeedHighlightTableViewCells addObject:cell];
		}
	}
}

#pragma mark - UITableViewDelegate
- (void)_setVisibleVideoPlay:(BOOL)play {
	for (UITableViewCell *cell in _visibleFeedHighlightTableViewCells) {
		BSFeedHighlightTableViewCell *highlightCell = (BSFeedHighlightTableViewCell *)cell;
		if (play) {
			[highlightCell checkIfCanPlayVideo];
		}
		else {
			[highlightCell pauseVideo];
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView == self.tableView) {
		[self _setVisibleVideoPlay:YES];
	}
}

- (void)_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath highlight:(BSHighlightMO *)highlight {
	if (indexPath.row == 0) {
		
	} else if (indexPath.row == [self _getCommentsCountForHighlight:highlight] + 1) {
		
	} else {
		// NOTE: only the multiply blend area is tappable
		BSFeedCommentTableViewCell *cell = (BSFeedCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
		if (cell.isTapInMultiplyBlendViewArea) {
			[self _showCommentViewWithPostMode:NO highlight:highlight];
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_isSingleFeed) {
		if (indexPath.section == 0) {
			
		} else {
			[self _tableView:tableView didSelectRowAtIndexPath:indexPath highlight:_highlight];
		}
	} else {
		if (indexPath.section == 0) {
			
		} else if (indexPath.section < _aryFeedsRecommended.count + 1) {
			
		} else if (indexPath.section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			// load more
		} else {
			NSInteger sectionHighlight = indexPath.section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				
			} else {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				[self _tableView:tableView didSelectRowAtIndexPath:indexPath highlight:highlight];
			}
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

- (CGFloat)_tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath highlight:(BSHighlightMO *)highlight {
	if (indexPath.row == 0) {
		return 112;
	}
	else if (indexPath.row == highlight.comments_countValue + 1) {
		return kTableViewCellActionHeight;
	}
	else {
		return UITableViewAutomaticDimension;
	}
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_isSingleFeed) {
		if (indexPath.section == 0) {
			return tableView.width;
		} else {
			return [self _tableView:tableView estimatedHeightForRowAtIndexPath:indexPath highlight:_highlight];
		}
	} else {
		if (indexPath.section == 0) {
			return 60;
		} else if (indexPath.section < _aryFeedsRecommended.count + 1) {
			return 350;
		} else if (indexPath.section == _aryFeedsRecommended.count + _aryFeeds.count * 2 + 1) {
			return BSLoadMoreCellHeight;// load more
		} else {
			NSInteger sectionHighlight = indexPath.section - _aryFeedsRecommended.count - 1;
			if (sectionHighlight % 2 == 0) {
				return tableView.width;
			} else {
				sectionHighlight = sectionHighlight / 2;
				BSHighlightMO *highlight = _aryFeeds[sectionHighlight];
				
				return [self _tableView:tableView estimatedHeightForRowAtIndexPath:indexPath highlight:highlight];
			}
		}
	}
}

#pragma mark - event tracking
- (NSString *) pageName {
	if (_highlight) {
		return nil;
	} else {
		return @"feed";
	}
}

- (NSString *) guideName {
	switch (_feedPopUpViewModel) {
		case BSFeedPopUpViewModel_Sports:
			return @"add_sports";
		case BSFeedPopUpViewModel_Friends:
			return @"follow_people";
		case BSFeedPopUpViewModel_Capture:
			return @"capture_video";
		case BSFeedPopUpViewModel_Team:
			return @"create_team";
		default:
			return nil;
	}
}
@end
