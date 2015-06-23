//
//  BSProfileViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileViewController.h"
#import "BSUsersViewController.h"
#import "BSTeamSettingsViewController.h"

#import "BSMapAnnotation.h"
#import "BSAvatarButton.h"
#import "BSLoadMoreCollectionViewCell.h"

#import "BSProfileNotificationTableViewDataSource.h"
#import "BSProfileHighlightCollectionViewDataSource.h"
#import "BSProfileTeamTableViewDataSource.h"
#import "BSProfileEventTableViewDataSource.h"
#import "BSTeamEventHighlightCollectionViewDataSource.h"
#import "BSTeamMemberTableViewDataSource.h"

#import "BSUserInfoHttpRequest.h"
#import "BSUserPublicFollowHttpRequest.h"
#import "BSUserPrivateFollowHttpRequest.h"
#import "BSUserUnfollowHttpRequest.h"
#import "BSMeNotificationHttpRequest.h"

#import "BSTeamInfoHttpRequest.h"
#import "BSTeamFollowHttpRequest.h"
#import "BSTeamUnfollowHttpRequest.h"
#import "BSTeamApplyHttpRequest.h"
#import "BSTeamAcceptInvitationHttpRequest.h"
#import "BSTeamRejectInvitationHttpRequest.h"

#import "BSEventInfoHttpRequest.h"
#import "BSEventFollowHttpRequest.h"
#import "BSEventUnfollowHttpRequest.h"

#import "FXBlurView.h"
#import "INTULocationManager.h"
#import "NSDate+Utilities.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM (NSUInteger, BSProfileTab) {
	BSProfileTabUserHighlight,
	BSProfileTabUserTeam,
	BSProfileTabUserEvent,
	BSProfileTabUserNotification,
	
	BSProfileTabTeamHighlight,
	BSProfileTabTeamMember,
	
	BSProfileTabEventHighlight,
	BSProfileTabEventMember,
	BSProfileTabEventMap,
};

typedef NS_ENUM (NSUInteger, BSProfileDataType) {
	BSProfileDataTypeUserMe,
	BSProfileDataTypeUserOther,
	BSProfileDataTypeEvent,
	BSProfileDataTypeTeam,
};

typedef id (^BSDatasourceLazyLoadBlock) (void);

#pragma mark - BSProfileTabModel
@interface BSProfileTabModel : NSObject
@property (nonatomic, assign, readonly) BSProfileTab tab;
@property (nonatomic, strong, readonly) NSString *buttonImageName;
@property (nonatomic, strong, readonly) id datasource;

+ (instancetype)modelWithTab:(BSProfileTab)tab buttonImageName:(NSString *)buttonImageName datasourceLazyLoad:(BSDatasourceLazyLoadBlock)datasourceLazyLoad;
- (id)initWithTab:(BSProfileTab)tab buttonImageName:(NSString *)buttonImageName datasourceLazyLoad:(BSDatasourceLazyLoadBlock)datasourceLazyLoad;

@end

@interface BSProfileTabModel()
{
	id _datasource;
	BSDatasourceLazyLoadBlock _datasourceLazyLoad;
}

@end

@implementation BSProfileTabModel

+ (instancetype)modelWithTab:(BSProfileTab)tab buttonImageName:(NSString *)buttonImageName datasourceLazyLoad:(BSDatasourceLazyLoadBlock)datasourceLazyLoad {
	return [[BSProfileTabModel alloc] initWithTab:tab buttonImageName:buttonImageName datasourceLazyLoad:datasourceLazyLoad];
}

- (id)initWithTab:(BSProfileTab)tab buttonImageName:(NSString *)buttonImageName datasourceLazyLoad:(BSDatasourceLazyLoadBlock)datasourceLazyLoad {
	self = [super init];
	if (self) {
		_tab = tab;
		_buttonImageName = buttonImageName;
		_datasourceLazyLoad = datasourceLazyLoad;
	}
	return self;
}

- (id)datasource {
	if (!_datasource && _datasourceLazyLoad) {
		_datasource = _datasourceLazyLoad();
		_datasourceLazyLoad = nil; // NOTE: nil it out to avoid loop-reference with BSProfileViewController.
	}
	return _datasource;
}

- (void)dealloc {
	
}

@end

#pragma mark - BSProfileViewController
@interface BSProfileViewController () <UITableViewDelegate, MKMapViewDelegate>
{
	NSArray *_aryTabModelsRuntime, *_aryTabButtonsDesign;
	UIRefreshControl *_refreshControlTableView;
	UIRefreshControl *_refreshControlCollectionView;
}
@property (nonatomic, assign) BSProfileDataType dataType;
@property (nonatomic, assign) NSUInteger currentTabIndex;
@property (nonatomic, strong) id currentDataSource;
@property (nonatomic, strong) BSUserMO *user;
@property (nonatomic, strong) BSEventMO *event;
@property (nonatomic, strong) BSTeamMO *team;

@property (nonatomic, strong) BSMapAnnotation *mapAnnotation;

// header
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *blendView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blendViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabView1WidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *followingView;
@property (weak, nonatomic) IBOutlet UILabel *lblSubname;

@property (weak, nonatomic) IBOutlet UIButton *btnTab1;
@property (weak, nonatomic) IBOutlet UIButton *btnTab2;
@property (weak, nonatomic) IBOutlet UIButton *btnTab3;
@property (weak, nonatomic) IBOutlet UIButton *btnTab4;
@property (weak, nonatomic) IBOutlet FXBlurView *multiplyView;

@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnJoinHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnIgnore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnIgnoreWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *invitedLabel;

@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowersCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewHighlight;
@property (weak, nonatomic) IBOutlet UIView *mapHolderView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *privacyView;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;

@end

@implementation BSProfileViewController

+ (instancetype)instanceFromStoryboard {
	BSProfileViewController *vc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileViewController"];
	vc.dataType = BSProfileDataTypeUserMe;
	vc.user = [BSDataManager sharedInstance].currentUser;
	return vc;
}

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user {
	NSParameterAssert([user isKindOfClass:[BSUserMO class]]);
	
	BSProfileViewController *vc = [BSProfileViewController instanceFromStoryboard];
	if (user == [BSDataManager sharedInstance].currentUser) {
		vc.dataType = BSProfileDataTypeUserMe;
	} else {
		vc.dataType = BSProfileDataTypeUserOther;
	}
	vc.user = user;
	return vc;
}

+ (instancetype)instanceFromStoryboardWithTeam:(BSTeamMO *)team {
	NSParameterAssert([team isKindOfClass:[BSTeamMO class]]);
	
	BSProfileViewController *vc = [BSProfileViewController instanceFromStoryboard];
	vc.dataType = BSProfileDataTypeTeam;
	vc.team = team;
	return vc;
}

+ (instancetype)instanceFromStoryboardWithEvent:(BSEventMO *)event {
	NSParameterAssert([event isKindOfClass:[BSEventMO class]]);
	
	BSProfileViewController *vc = [BSProfileViewController instanceFromStoryboard];
	vc.dataType = BSProfileDataTypeEvent;
	vc.event = event;
	return vc;
}

+ (instancetype)instanceFromStoryboardWithModel:(id)model {
	if ([model isKindOfClass:[BSUserMO class]]) {
		return [BSProfileViewController instanceFromStoryboardWithUser:model];
	} else if ([model isKindOfClass:[BSTeamMO class]]){
		return [BSProfileViewController instanceFromStoryboardWithTeam:model];
	} else if ([model isKindOfClass:[BSEventMO class]]){
		return [BSProfileViewController instanceFromStoryboardWithEvent:model];
	} else
		return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;

	_btnBack.imageView.contentMode = UIViewContentModeCenter;
	_aryTabButtonsDesign = @[_btnTab1, _btnTab2, _btnTab3, _btnTab4];
	_followingView.hidden = YES;
	BOOL isFollowing;
	BSCustomHttpRequest *request = nil;
	_btnSettingOrFollow.showBackgroundImage = YES;
	_btnSettingOrFollow.enableAfterFollowed = YES;
	
	__weak typeof(self) weakSelf = self;
	switch (_dataType) {
		case BSProfileDataTypeUserMe:
		case BSProfileDataTypeUserOther:
		{
			_btnJoinHeightConstraint.constant = 0;
			if (_dataType == BSProfileDataTypeUserMe) {
				_user = [BSDataManager sharedInstance].currentUser;// Re-asign user after login to avoid nil out
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightDidPosted:) name:kHighlightDidPostedNotification object:nil];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightDidRemoved:) name:kHighlightDidRemovedNotification object:nil];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_teamDidAdded:) name:kTeamDidAddedNotification object:nil];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_teamDidRemoved:) name:kTeamDidRemovedNotification object:nil];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_followStateDidChanged:) name:kFollowStateDidChangedNotification object:nil];
			}
			[_btnSettingOrFollow configWithUser:_user];
			
			id dataModel = _user;
			NSMutableArray *aryTabs = [@[[BSProfileTabModel modelWithTab:BSProfileTabUserHighlight buttonImageName:@"profile_capture_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSProfileHighlightCollectionViewDataSource dataSourceWithUser:dataModel]]; }],
										 [BSProfileTabModel modelWithTab:BSProfileTabUserTeam buttonImageName:@"profile_team_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSProfileTeamTableViewDataSource dataSourceWithUser:dataModel]]; }],
										 [BSProfileTabModel modelWithTab:BSProfileTabUserEvent buttonImageName:@"profile_location_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSProfileEventTableViewDataSource dataSourceWithUser:dataModel]]; }],
										 [BSProfileTabModel modelWithTab:BSProfileTabUserNotification buttonImageName:@"profile_notification_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSProfileNotificationTableViewDataSource dataSourceWithUser:dataModel]]; }]] mutableCopy];
			if (_dataType == BSProfileDataTypeUserMe) {
				// NOTE: force to preload my teams/events data to sync data with notification tab.
				BSProfileTabModel *tabModel = aryTabs[1];
				[tabModel datasource];
				tabModel = aryTabs[2];
				[tabModel datasource];
			} else {
				[aryTabs removeLastObject];
			}
			_aryTabModelsRuntime = [NSArray arrayWithArray:aryTabs];
			
			BSUserInfoHttpRequest *requestUserProfile = [BSUserInfoHttpRequest request];
			requestUserProfile.user_id = _user.identifierValue;
			request = requestUserProfile;
			
			_followingView.hidden = NO;
			isFollowing = _user.is_followingValue;
			
			if (![self hidesBottomBarWhenPushed]) {
				[self adjustScrollViewInsets:_collectionViewHighlight];
				[self adjustScrollViewInsets:_tableView];
			}
			break;
		}
		case BSProfileDataTypeTeam:
		{
			[_btnSettingOrFollow configWithTeam:_team];
			
			id dataModel = _team;
			_aryTabModelsRuntime = @[[BSProfileTabModel modelWithTab:BSProfileTabTeamHighlight buttonImageName:@"profile_capture_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSTeamEventHighlightCollectionViewDataSource dataSourceWithTeam:dataModel]]; }],
									 [BSProfileTabModel modelWithTab:BSProfileTabTeamMember buttonImageName:@"explore_member" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSTeamMemberTableViewDataSource dataSourceWithTeam:dataModel]]; }]];
			
			BSTeamInfoHttpRequest *requestTeamInfo = [BSTeamInfoHttpRequest request];
			requestTeamInfo.teamId = _team.identifierValue;
			request = requestTeamInfo;
			
			isFollowing = _team.is_followingValue;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kTeamProfileDidShownNotification object:_team];
			break;
		}
		case BSProfileDataTypeEvent:
		{
			[_btnSettingOrFollow configWithEvent:_event];
			
			id dataModel = _event;
			_btnJoinHeightConstraint.constant = 0;
			_aryTabModelsRuntime = @[[BSProfileTabModel modelWithTab:BSProfileTabEventHighlight buttonImageName:@"profile_capture_icon" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSTeamEventHighlightCollectionViewDataSource dataSourceWithEvent:dataModel]]; }],
									 [BSProfileTabModel modelWithTab:BSProfileTabEventMember buttonImageName:@"explore_member" datasourceLazyLoad:^id{ return [weakSelf _refreshDataSource:[BSEventFollowersTableViewDataSource dataSourceWithEvent:dataModel]]; }],
									 [BSProfileTabModel modelWithTab:BSProfileTabEventMap buttonImageName:@"profile_location_icon" datasourceLazyLoad:^id{ return nil; }]];
			
			BSEventInfoHttpRequest *requestEventInfo = [BSEventInfoHttpRequest request];
			requestEventInfo.eventId = _event.identifierValue;
			request = requestEventInfo;
			
			isFollowing = _event.is_followingValue;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kEventProfileDidShownNotification object:_event];
			break;
		}
	}
	_btnAvatar.enabled = NO;
	
	if (_aryTabModelsRuntime.count < _aryTabButtonsDesign.count) {
		_headerViewLeadingConstraint.constant = _headerViewTrailingConstraint.constant = 28;
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_tabView1WidthConstraint.firstItem attribute:_tabView1WidthConstraint.firstAttribute relatedBy:_tabView1WidthConstraint.relation toItem:_tabView1WidthConstraint.secondItem attribute:_tabView1WidthConstraint.secondAttribute multiplier:_aryTabModelsRuntime.count constant:-1];
		[_highlightView.superview removeConstraint:_tabView1WidthConstraint];
		[_highlightView.superview addConstraint:constraint];
		for (int i = (int)_aryTabButtonsDesign.count - 1; i >= _aryTabModelsRuntime.count; i--) {
			[((UIButton *)_aryTabButtonsDesign[i]).superview removeFromSuperview];
		}
	}
	for (UIButton *btn in _aryTabButtonsDesign) {
		btn.titleLabel.numberOfLines = 1;
		btn.titleLabel.adjustsFontSizeToFitWidth = YES;
		btn.titleLabel.minimumScaleFactor = 0.4;
		btn.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	}
	
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        id dataModel = result.dataModel;
        
		[self _updateUIWithModelInfo];
		
		if (isFollowing != [dataModel is_followingValue]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:dataModel];
		}
	} failedBlock:^(BSHttpResponseDataModel *result) {
		if (result.code == 100) {
			[BSUIGlobal showAlertMessage:result.error.localizedDescription cancelTitle:ZPLocalizedString(@"Go back") cancelHandler:^{
				[self btnBackTapped:nil];
			} actionTitle:nil actionHandler:nil];
		}
	}];
	
	[_tableView setGlobalUI];
	_tableView.delegate = self;
	
	_refreshControlTableView = [[UIRefreshControl alloc] init];
	[_refreshControlTableView addTarget:self action:@selector(_refreshTableView:) forControlEvents:UIControlEventValueChanged];
	[_tableView addSubview:_refreshControlTableView];
	
	_refreshControlCollectionView = [[UIRefreshControl alloc] init];
	[_refreshControlCollectionView addTarget:self action:@selector(_refreshCollectionView:) forControlEvents:UIControlEventValueChanged];
	[_collectionViewHighlight addSubview:_refreshControlCollectionView];
	[_collectionViewHighlight registerNib:[UINib nibWithNibName:BSLoadMoreCollectionViewCell.className bundle:nil] forCellWithReuseIdentifier:BSLoadMoreCollectionViewCell.className];
	
	_currentTabIndex = NSUIntegerMax;
	[self _selectedTabAtIndex:0 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
	self.btnBack.hidden = self.navigationController.viewControllers.count == 1;
	
	_multiplyView.dynamic = YES;
	[self _updateUIWithModelInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	_multiplyView.dynamic = NO;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_updateUIWithModelInfo {
	for (BSProfileTabModel *tabModel in _aryTabModelsRuntime) {
		UIButton *btn = _aryTabButtonsDesign[[_aryTabModelsRuntime indexOfObject:tabModel]];
		
		NSString *title = nil;
		switch (tabModel.tab) {
			case BSProfileTabUserHighlight:
				title = [BSUtility formatValue:_user.highlights_countValue];
				break;
				
			case BSProfileTabUserTeam:
				title = [BSUtility formatValue:_user.teams_countValue];
				break;
				
			case BSProfileTabUserEvent:
				title = [BSUtility formatValue:_user.events_countValue];
				break;
				
			case BSProfileTabUserNotification:
			{
				BSProfileNotificationTableViewDataSource *ds = tabModel.datasource;
				title = [BSUtility formatValue:ds.notificationsNewer.count];
				break;
			}
			case BSProfileTabTeamHighlight:
				title = [BSUtility formatValue:_team.highlights_countValue];
				break;
				
			case BSProfileTabTeamMember:
				title = [BSUtility formatValue:_team.members_countValue];
				break;
				
			case BSProfileTabEventHighlight:
				title = [BSUtility formatValue:_event.highlights_countValue];
				break;
				
			case BSProfileTabEventMember:
				title = [BSUtility formatValue:_event.followers_countValue];
				break;
				
			case BSProfileTabEventMap:
			{
				title = @"-";
				self.mapAnnotation.coordinate = _event.coordinate;
				[_mapView setRegion:MKCoordinateRegionMakeWithDistance(_event.coordinate, 0.002, 0.002) animated:NO];
				[[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
					switch (status) {
						case INTULocationStatusSuccess:
						{
							[btn setTitle:[BSUtility distanceBetweenLocation1:currentLocation.coordinate location2:_event.coordinate] forState:UIControlStateNormal];
							break;
						}
						default:
							break;
					}
				}];
				break;
			}
		}
		[btn setImage:[UIImage imageNamed:tabModel.buttonImageName] forState:UIControlStateNormal];
		[btn setTitle:title forState:UIControlStateNormal];
	}
	
	NSString *name = nil, *subname = nil;
	switch (_dataType) {
		case BSProfileDataTypeUserMe:
		case BSProfileDataTypeUserOther:
		{
			name = _user.name_id;
			subname = _user.name_human_readable;
			[_btnAvatar configWithUser:_user];
			_lblFollowingCount.text = [BSUtility formatValue:_user.following_countValue];
			_lblFollowersCount.text = [BSUtility formatValue:_user.followers_countValue];
			
			if (_dataType == BSProfileDataTypeUserOther) {
				BOOL isPublic = _user.is_publicValue || _user.is_followingValue;
				_containerView.hidden = !isPublic;
				_privacyView.hidden = isPublic;
				_privacyLabel.text = ZPLocalizedString(@"PRIVATE ACCOUNT");
			}

			break;
		}
		case BSProfileDataTypeTeam:
		{
			name = _team.name;
			for (BSSportMO *sport in _team.sportsSortedByAlphabet) {
				if (subname) {
					subname = [NSString stringWithFormat:@"%@, %@", subname, sport.nameLocalized];
				} else {
					subname = sport.nameLocalized;
				}
			}
			[_btnAvatar configWithTeam:_team];
			
			[self _configTeamJoinBtn];
			
			if (_team.is_manager == nil || _team.is_member == nil || _team.is_following == nil || _team.is_private == nil) {
				_containerView.hidden = YES;
				_privacyView.hidden = YES;
			} else if (!_team.is_managerValue && !_team.is_memberValue && _team.is_privateValue) {
				_containerView.hidden = YES;
				_privacyView.hidden = NO;
				_privacyLabel.text = ZPLocalizedString(@"PRIVATE TEAM");
			} else {
				_containerView.hidden = NO;
				_privacyView.hidden = YES;
			}
			break;
		}
		case BSProfileDataTypeEvent:
		{
			name = _event.name;
			static NSString *FORMAT = @"MMM dd, yyyy";
			subname = [NSString stringWithFormat:@"%@ - %@", [_event.start_time stringWithFormat:FORMAT], _event.end_time ? [_event.end_time stringWithFormat:FORMAT] : @""];
			[_btnAvatar configWithEvent:_event];
			break;
		}
	}
	self.title = _lblName.text = name.uppercaseString;
	_lblSubname.text = subname.uppercaseString;
}

- (void)_hideTableView:(BOOL)tableView collectionView:(BOOL)collectionView mapView:(BOOL)mapView {
	_tableView.hidden = tableView;
	_collectionViewHighlight.hidden = collectionView;
	_mapHolderView.hidden = mapView;
}

- (void)_selectedTabAtIndex:(NSUInteger)index animated:(BOOL)animated {
	if (_currentTabIndex == index) {
		return;
	}
	
	_currentTabIndex = index;
	UIButton *btnSelected = _aryTabButtonsDesign[index];
	for (UIButton *btn in _aryTabButtonsDesign) {
		btn.selected = NO;
	}
	btnSelected.selected = YES;
	
	BSProfileTabModel *tabModel = _aryTabModelsRuntime[index];
	_currentDataSource = tabModel.datasource;
	
	if ([_currentDataSource conformsToProtocol:@protocol(UITableViewDataSource)]) {
		[self _hideTableView:NO collectionView:YES mapView:YES];
		self.tableView.dataSource = _currentDataSource;
		self.tableView.delegate = _currentDataSource;
		[self.tableView reloadData];
	} else if ([_currentDataSource conformsToProtocol:@protocol(UICollectionViewDataSource)]) {
		[self _hideTableView:YES collectionView:NO mapView:YES];
		self.collectionViewHighlight.dataSource = _currentDataSource;
		self.collectionViewHighlight.delegate = _currentDataSource;
		[self.collectionViewHighlight reloadData];
	} else {
		[self _hideTableView:YES collectionView:YES mapView:NO];
	}
	
	[_refreshControlCollectionView endRefreshing];
	[_refreshControlTableView endRefreshing];
	
	[UIView animateWithDuration:animated ? kDefaultAnimateDuration : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
		_blendViewLeadingConstraint.constant = btnSelected.superview.left;
		[_blendView layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
}

- (BSBaseDataSource *)_refreshDataSource:(BSBaseDataSource *)ds refreshControl:(UIRefreshControl *)sender {
	[ds refreshDataWithSuccess:^{
		[self.tableView reloadData];
		[self _updateUIWithModelInfo];
		[sender endRefreshing];
	} faild:^(NSError *error) {
		[BSUIGlobal showError:error];
		[sender endRefreshing];
	}];
	return ds;
}

- (BSBaseDataSource *)_refreshDataSource:(BSBaseDataSource *)ds {
	return [self _refreshDataSource:ds refreshControl:nil];
}

- (void)_refreshTableView:(UIRefreshControl *)sender {
	[self _refreshDataSource:_currentDataSource refreshControl:sender];
}

- (void)_refreshCollectionView:(UIRefreshControl *)sender {
	[self _refreshDataSource:_currentDataSource refreshControl:sender];
}

#pragma mark - notifications
- (BSBaseDataSource *)_getDataSourceAtTabIndex:(NSUInteger)index {
	if (index < _aryTabModelsRuntime.count) {
		BSProfileTabModel *tabModel = _aryTabModelsRuntime[index];
		return tabModel.datasource;
	} else {
		return nil;
	}
}

- (void)_highlightDidPosted:(NSNotification *)notification {
	BSHighlightMO *highlight = notification.object;
	if (highlight) {
		BSProfileHighlightCollectionViewDataSource *ds = (BSProfileHighlightCollectionViewDataSource *)[self _getDataSourceAtTabIndex:0];
		if ([ds postNewHighlight:highlight]) {
			highlight.user.highlights_countValue += 1;
			[highlight.user addHighlightsObject:highlight];
			[self _updateUIWithModelInfo];
		}
	}
}

- (void)_highlightDidRemoved:(NSNotification *)notification {
	BSHighlightMO *highlight = notification.object;
	if (highlight) {
		BSProfileHighlightCollectionViewDataSource *ds = (BSProfileHighlightCollectionViewDataSource *)[self _getDataSourceAtTabIndex:0];
		if ([ds removeHighlight:highlight]) {
			highlight.user.highlights_countValue -= 1;
			[highlight.user removeHighlightsObject:highlight];
			[self _updateUIWithModelInfo];
		}
	}
}

- (void)_teamDidAdded:(NSNotification *)notification {
	BSUserMO *currentUser = [BSDataManager sharedInstance].currentUser;
	BSProfileTeamTableViewDataSource *ds = (BSProfileTeamTableViewDataSource *)[self _getDataSourceAtTabIndex:1];
	BSTeamMO *team = notification.object;
	if (team.is_memberValue) {
		if ([ds addJoinedTeam:team]) {
			currentUser.teams_countValue += 1;
			[currentUser addJoined_teamsObject:team];
			[self _updateUIWithModelInfo];
		}
	} else {
		if ([ds addFollowedTeam:team]) {
			currentUser.teams_countValue += 1;
			[currentUser addFollowed_teamsObject:team];
			[self _updateUIWithModelInfo];
		}
	}
}

- (void)_teamDidRemoved:(NSNotification *)notification {
	BSUserMO *currentUser = [BSDataManager sharedInstance].currentUser;
	BSProfileTeamTableViewDataSource *ds = (BSProfileTeamTableViewDataSource *)[self _getDataSourceAtTabIndex:1];
	BSTeamMO *team = notification.object;
	if ([ds removeJoinedTeam:team]) {
		currentUser.teams_countValue -= 1;
		[currentUser removeJoined_teamsObject:team];
		[self _updateUIWithModelInfo];
	}
}

- (void)_followStateDidChanged:(NSNotification *)notification {
	BSUserMO *currentUser = [BSDataManager sharedInstance].currentUser;
	
	id object = notification.object;
	if ([object isKindOfClass:[BSTeamMO class]]) {
		BSProfileTeamTableViewDataSource *ds = (BSProfileTeamTableViewDataSource *)[self _getDataSourceAtTabIndex:1];
		BSTeamMO *team = object;
		if (team.is_followingValue) {
			if ([ds addFollowedTeam:team]) {
				currentUser.teams_countValue += 1;
				[currentUser addFollowed_teamsObject:team];
			}
		} else {
			if ([ds removeFollowedTeam:team]) {
				currentUser.teams_countValue -= 1;
				[currentUser removeFollowed_teamsObject:team];
			}
		}
	} else if ([object isKindOfClass:[BSEventMO class]]) {
		BSProfileEventTableViewDataSource *ds = (BSProfileEventTableViewDataSource *)[self _getDataSourceAtTabIndex:2];
		BSEventMO *event = object;
		if (event.is_followingValue) {
			if ([ds addFollowedEvent:event]) {
				currentUser.events_countValue += 1;
				[currentUser addEventsObject:event];
			}
		} else {
			if ([ds removeFollowedEvent:event]) {
				currentUser.events_countValue -= 1;
				[currentUser removeEventsObject:event];
			}
		}
	}
	[self _updateUIWithModelInfo];
}

- (void) _removeNotificationsOfTeamInvite:(BSTeamMO *)team {
	[[NSNotificationCenter defaultCenter] postNotificationName:kTeamDidIgnoreOrAcceptInvitationNotification object:team];
}

#pragma mark - actions
- (IBAction)btnTabTapped:(id)sender {
	NSUInteger index = [_aryTabButtonsDesign indexOfObject:sender];
	[self _selectedTabAtIndex:index animated:YES];
}

- (IBAction)btnFollowingTapped:(id)sender {
	BSUsersViewController *vc = [BSUsersViewController instanceOfFollowingWithUser:_user];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFollowerTapped:(id)sender {
	BSUsersViewController *vc = [BSUsersViewController instanceOfFollowersWithUser:_user];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)_configTeamJoinBtn {
	self.invitedLabel.hidden = YES;
	self.btnIgnoreWidthConstraint.constant = 0;
	self.btnJoinHeightConstraint.constant = 0;
	
	if (self.team.is_member != nil && self.team.is_manager != nil && !self.team.is_memberValue && !self.team.is_managerValue) {
		self.btnJoinHeightConstraint.constant = 44;

		if (self.team.is_invitedValue) {
			self.invitedLabel.hidden = NO;
			self.btnIgnoreWidthConstraint.constant = self.view.width / 2;
			[self.btnJoin setTitle:ZPLocalizedString(@"ACCEPT") forState:UIControlStateNormal];
			[self.btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if (self.team.is_applyingValue) {
			[self.btnJoin setTitle:ZPLocalizedString(@"PENDING REQUEST TO JOIN...") forState:UIControlStateNormal];
			[self.btnJoin setTitleColor:[UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.0] forState:UIControlStateNormal];
		} else if (self.team.is_joinableValue) {
			[self.btnJoin setTitle:ZPLocalizedString(@"JOIN") forState:UIControlStateNormal];
			[self.btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else {
			self.btnJoinHeightConstraint.constant = 0;
		}
	}
	
	self.btnJoin.titleLabel.numberOfLines = 1;
	self.btnJoin.titleLabel.minimumScaleFactor = 0.5;
}

- (IBAction)btnJoinTapped:(id)sender {
	if (self.team && !self.team.is_applyingValue && !self.team.is_memberValue && !self.team.is_managerValue) {
		
		if (self.team.is_invitedValue) {
			self.team.is_memberValue = YES;
			self.team.is_invitedValue = NO;
			self.team.members_countValue++;
			[self.team addMembersObject:[BSDataManager sharedInstance].currentUser];
			[self _updateUIWithModelInfo];

			BSTeamAcceptInvitationHttpRequest *request = [BSTeamAcceptInvitationHttpRequest request];
			request.teamId = self.team.identifierValue;
			[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
				[self _removeNotificationsOfTeamInvite:self.team];
			} failedBlock:^(BSHttpResponseDataModel *result) {
				self.team.is_memberValue = NO;
				self.team.is_invitedValue = YES;
				self.team.members_countValue--;
				[self.team removeMembersObject:[BSDataManager sharedInstance].currentUser];
				
				[self _updateUIWithModelInfo];
			}];
			
		} else {
			[BSUIGlobal showActionSheetTitle:nil isDestructive:YES actionTitle:ZPLocalizedString(@"Apply to Join") actionHandler:^{
				self.team.is_applyingValue = YES;
				[self _configTeamJoinBtn];
				
				BSTeamApplyHttpRequest *request = [BSTeamApplyHttpRequest request];
				request.teamId = self.team.identifierValue;
				[request postRequestWithSucceedBlock:nil failedBlock:^(BSHttpResponseDataModel *result) {
					self.team.is_applyingValue = NO;
					[self _configTeamJoinBtn];
				}];
			}];
		}
	}
}

- (IBAction)btnBackTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnIgnoreTapped:(id)sender {
	if (self.team && self.team.is_invitedValue) {
		BSTeamRejectInvitationHttpRequest *request = [BSTeamRejectInvitationHttpRequest request];
		request.teamId = self.team.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[self _removeNotificationsOfTeamInvite:self.team];
		} failedBlock:^(BSHttpResponseDataModel *result) {
			self.team.is_invitedValue = YES;
			[self _updateUIWithModelInfo];
		}];
	}
	
	self.team.is_invitedValue = NO;
	[self _updateUIWithModelInfo];
}

#pragma mark - MKMapViewDelegate
- (BSMapAnnotation *)mapAnnotation {
	if (!_mapAnnotation) {
		_mapAnnotation = [[BSMapAnnotation alloc] init];
		[_mapView addAnnotation:_mapAnnotation];
	}
	return _mapAnnotation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	static NSString *MyLocationId = @"MyLocation";
	
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:MyLocationId];
	if (!annotationView) {
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MyLocationId];
		annotationView.canShowCallout = YES;
		annotationView.image = [UIImage imageNamed:@"profile_locationpin_icon"];
	}
	
	return annotationView;
}

#pragma mark - event tracking
- (NSString *) pageName {
	BSProfileTab tab = BSProfileTabUserHighlight;
	
	if (_aryTabModelsRuntime) {
		tab = ((BSProfileTabModel *)_aryTabModelsRuntime[_currentTabIndex]).tab;
	}

	switch (_dataType) {
		case BSProfileDataTypeUserMe:
		case BSProfileDataTypeUserOther:
		{
			switch (tab) {
				case BSProfileTabUserHighlight:
					return @"profile_videos";
				case BSProfileTabUserTeam:
					return @"profile_teams";
				case BSProfileTabUserEvent:
					return @"profile_events";
				case BSProfileTabUserNotification:
					return @"profile_notifications";
				default:
					return nil;
			}
		}
		case BSProfileDataTypeTeam:
		{
			switch (tab) {
				case BSProfileTabUserHighlight:
				case BSProfileTabTeamHighlight:
					return @"team_videos";
				case BSProfileTabTeamMember:
					return @"team_members";
				default:
					return nil;
			}
		}
		case BSProfileDataTypeEvent:
		{
			switch (tab) {
				case BSProfileTabUserHighlight:
				case BSProfileTabEventHighlight:
					return @"event_videos";
				case BSProfileTabEventMember:
					return @"event_members";
				case BSProfileTabEventMap:
					return @"event_map";
				default:
					return nil;
			}
		}
		default:
			return nil;
	}
}

- (NSString *) useCase {
	return _dataType == BSProfileDataTypeUserMe ? @"me" : nil;
}

- (NSDictionary *) pageViewProperties {
	switch (_dataType) {
		case BSProfileDataTypeUserMe:
		case BSProfileDataTypeUserOther:
			return @{@"user_name":_user.name_id, @"user_id":_user.identifier};
		case BSProfileDataTypeTeam:
			return @{@"team_name":_team.name, @"team_id":_team.identifier};
		case BSProfileDataTypeEvent:
			return @{@"event_name":_event.name, @"event_id":_event.identifier};
		default:
			return nil;
	}
}
@end
