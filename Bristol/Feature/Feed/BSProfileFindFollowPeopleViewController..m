//
//  BSProfileFindFollowPeopleViewController.m
//  Bristol
//
//  Created by Bo on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileFindFollowPeopleViewController.h"
#import "BSFollowPeopleTableViewCell.h"
#import "BSActivityIndicatorButton.h"

#import "BSUserMO.h"
#import "BSUsersDataModel.h"

#import "BSUserPublicFollowHttpRequest.h"
#import "BSExploreUsersToFollowHttpRequest.h"
#import "BSExploreCheckFriendsOnFacebookHttpRequest.h"
#import "BSExploreCheckFriendsOnTwitterHttpRequest.h"
#import "BSExploreCheckFriendsOnInstagramHttpRequest.h"

#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"

#import "AFNetworking.h"

@interface BSProfileFindFollowPeopleViewController () <UITableViewDataSource, UITableViewDelegate>
{
	NSArray *_usersZepp, *_usersFB, *_usersTwitter, *_usersIG;
	NSArray *_tabButtons;
	NSUInteger _currentTabIndex;

	BSExploreUsersToFollowHttpRequest *_requestZepp;
}
@property (nonatomic) NSArray *usersCurrent;

@property (weak, nonatomic) IBOutlet UITableView *followTableView;
@property (weak, nonatomic) IBOutlet UIView *blendView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blendViewLeadingLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIButton *btnZepp;
@property (weak, nonatomic) IBOutlet UIButton *btnFB;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnIG;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblNoFriend;
@property (weak, nonatomic) IBOutlet BSActivityIndicatorButton *btnFollowAll;

@end

@implementation BSProfileFindFollowPeopleViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileFindFollowPeopleViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = ZPLocalizedString(@"FIND PEOPLE TO FOLLOW");
	
	_btnFB.selected = [ZPFacebookSharer isConnected];
	_btnTwitter.selected = [ZPTwitterSharer isConnected];
	_btnIG.selected = [ZPInstagramSharer isConnected];
	_tabButtons = @[_btnZepp, _btnFB, _btnTwitter, _btnIG];

	if ([BSUtility getPopUpFirstActionDate:kFirstAddFriendsDate] == nil) {
		[BSUtility savePopUpFirstActionDate:[NSDate date] withKey:kFirstAddFriendsDate];
	}

	_currentTabIndex = -1;
	[self _selectedTabAtIndex:0 animated:YES];
}

- (void)setUsersCurrent:(NSArray *)usersCurrent {
	_usersCurrent = usersCurrent;
	
	NSString *platform = @"";
	NSUInteger count = 0;
	switch (_currentTabIndex) {
		case 1:
		{
			platform = @"Facebook";
			count = _usersFB.count;
			break;
		}
		case 2:
		{
			platform = @"Twitter";
			count = _usersTwitter.count;
			break;
		}
		case 3:
		{
			platform = @"Instagram";
			count = _usersIG.count;
			break;
		}
	}
	NSString *format = ZPLocalizedString(@"You have %d %@ friends on %@.");
	_lblFriendsCount.text = [NSString stringWithFormat:format, @(count), platform, [BSUtility appNameLocalized]];
	_lblNoFriend.text = [NSString stringWithFormat:ZPLocalizedString(@"You have no %@ friend on %@."), platform, [BSUtility appNameLocalized]];
	if (_usersCurrent) {
		_lblNoFriend.hidden = _usersCurrent.count > 0;
	} else {
		_lblNoFriend.hidden = YES;
	}
	
	BOOL hasFollowAll = YES;
	for (BSUserMO *user in _usersCurrent) {
		if (!user.is_followingValue && user.is_publicValue) {
			hasFollowAll = NO;
			break;
		}
	}
	[self _showHeaderView:!hasFollowAll];
}

- (void)_showHeaderView:(BOOL)show {
	_followTableView.tableHeaderView = show ? _headerView : nil;
}

- (IBAction)btnRecommendTapped:(UIButton *)sender {
	[self _selectedTabAtIndex:[_tabButtons indexOfObject:sender] animated:YES];
}

- (IBAction)btnFacebookTapped:(UIButton *)sender {
	[self _selectedTabAtIndex:[_tabButtons indexOfObject:sender] animated:YES];
}

- (IBAction)btnTwitterTapped:(UIButton *)sender {
	[self _selectedTabAtIndex:[_tabButtons indexOfObject:sender] animated:YES];
}

- (IBAction)btnInstagramTapped:(UIButton *)sender {
	[self _selectedTabAtIndex:[_tabButtons indexOfObject:sender] animated:YES];
}

- (void)_setFollowAllButtonWithIsFinding:(BOOL)isFinding {
	_btnFollowAll.enabled = !isFinding;
	[_btnFollowAll setTitle:isFinding ? ZPLocalizedString(@"Finding") : ZPLocalizedString(@"FOLLOW ALL") forState:UIControlStateNormal];
}

- (void)_selectedTabAtIndex:(NSUInteger)index animated:(BOOL)animated {
	if (_currentTabIndex == index) {
		return;
	}

	_currentTabIndex = index;
	UIButton *btn = _tabButtons[index];
	[btn.superview layoutIfNeeded];
	[UIView animateWithDuration:animated ? kDefaultAnimateDuration : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    _blendViewLeadingLayoutConstraint.constant = btn.centerX - _blendView.width / 2;
	    [_blendView layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];

	switch (_currentTabIndex) {
		case 0:
		{
			self.usersCurrent = _usersZepp;

			if (!_usersZepp && !_requestZepp) {
				_requestZepp = [BSExploreUsersToFollowHttpRequest request];
				_requestZepp.user_id = [BSDataManager sharedInstance].currentUser.identifierValue;
				[_requestZepp postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
				    BSUsersDataModel *usersDataModel = (BSUsersDataModel *)result.dataModel;
				    _usersZepp = usersDataModel.users;
					if (_currentTabIndex == index) {
						self.usersCurrent = _usersZepp;
						[_followTableView reloadData];
					}

				    _requestZepp = nil;
					[self _setFollowAllButtonWithIsFinding:NO];
				} failedBlock: ^(BSHttpResponseDataModel *result) {
					_requestZepp = nil;
					[self _setFollowAllButtonWithIsFinding:NO];
				}];
			}
			[self _setFollowAllButtonWithIsFinding:_requestZepp != nil];
			break;
		}
		case 1:
		{
			self.usersCurrent = _usersFB;
			
			if (_usersFB) {
				[self _setFollowAllButtonWithIsFinding:NO];
			} else {
				[self _setFollowAllButtonWithIsFinding:YES];
				
				ZPVoidBlock getFriends = ^ {
					[ZPFacebookSharer getFriendsIdWithSuccessHandler:^(NSArray *array) {
						if (array.count > 0) {
							BSExploreCheckFriendsOnFacebookHttpRequest *request = [BSExploreCheckFriendsOnFacebookHttpRequest request];
							request.ids = array;
							[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
								BSUsersDataModel *usersDataModel = (BSUsersDataModel *)result.dataModel;
								if (usersDataModel.users) {
									_usersFB = usersDataModel.users;
								} else {
									_usersFB = [NSArray array];
								}
								if (_currentTabIndex == index) {
									self.usersCurrent = _usersFB;
									[_followTableView reloadData];
								}
								
								[self _setFollowAllButtonWithIsFinding:NO];
							} failedBlock:^(BSHttpResponseDataModel *result) {
								[self _setFollowAllButtonWithIsFinding:NO];
							}];
						} else {
							self.usersCurrent = _usersFB = [NSArray array];
						}
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				};
				if ([ZPFacebookSharer isConnected]) {
					getFriends();
				} else {
					[ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
						btn.selected = YES;
						getFriends();
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				}
			}
			break;
		}
		case 2:
		{
			self.usersCurrent = _usersTwitter;
			
			if (_usersTwitter) {
				[self _setFollowAllButtonWithIsFinding:NO];
			} else {
				[self _setFollowAllButtonWithIsFinding:YES];
				
				ZPVoidBlock getFriends = ^ {
					[ZPTwitterSharer getFriendsIdWithSuccessHandler:^(NSArray *array) {
						if (array.count > 0) {
							BSExploreCheckFriendsOnTwitterHttpRequest *request = [BSExploreCheckFriendsOnTwitterHttpRequest request];
							request.ids = array;
							[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
								BSUsersDataModel *usersDataModel = (BSUsersDataModel *)result.dataModel;
								if (usersDataModel.users) {
									_usersTwitter = usersDataModel.users;
								} else {
									_usersTwitter = [NSArray array];
								}
								if (_currentTabIndex == index) {
									self.usersCurrent = _usersTwitter;
									[_followTableView reloadData];
								}
								
								[self _setFollowAllButtonWithIsFinding:NO];
							} failedBlock:^(BSHttpResponseDataModel *result) {
								[self _setFollowAllButtonWithIsFinding:NO];
							}];
						} else {
							self.usersCurrent = _usersTwitter = [NSArray array];
						}
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				};
				if ([ZPTwitterSharer isConnected]) {
					getFriends();
				} else {
					[ZPTwitterSharer connectWithSuccessHandler:^(NSString *authToken, NSString *authTokenSecret) {
						btn.selected = YES;
						getFriends();
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				}
			}
			break;
		}
		case 3:
		{
			self.usersCurrent = _usersIG;
			
			if (_usersIG) {
				[self _setFollowAllButtonWithIsFinding:NO];
			} else {
				[self _setFollowAllButtonWithIsFinding:YES];
				
				ZPVoidBlock getFriends = ^ {
					[ZPInstagramSharer getFriendsIdWithSuccessHandler:^(NSArray *array) {
						if (array.count > 0) {
							BSExploreCheckFriendsOnInstagramHttpRequest *request = [BSExploreCheckFriendsOnInstagramHttpRequest request];
							request.ids = array;
							[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
								BSUsersDataModel *usersDataModel = (BSUsersDataModel *)result.dataModel;
								if (usersDataModel.users) {
									_usersIG = usersDataModel.users;
								} else {
									_usersIG = [NSArray array];
								}
								if (_currentTabIndex == index) {
									self.usersCurrent = _usersIG;
									[_followTableView reloadData];
								}
								
								[self _setFollowAllButtonWithIsFinding:NO];
							} failedBlock:^(BSHttpResponseDataModel *result) {
								[self _setFollowAllButtonWithIsFinding:NO];
							}];
						} else {
							self.usersCurrent = _usersIG = [NSArray array];
						}
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				};
				
				if ([ZPInstagramSharer isConnected]) {
					getFriends();
				} else {
					[ZPInstagramSharer connectWithShowInViewController:self type:ZPInstagramResponseTypeAccessToken successHandler:^(NSString *authToken) {
						btn.selected = YES;
						getFriends();
					} faildHandler:^(NSError *error) {
						[BSUIGlobal showError:error];
						[self _setFollowAllButtonWithIsFinding:NO];
					}];
				}
			}
			break;
		}
	}

	[_followTableView reloadData];
}

- (IBAction)btnFollowAllTapped:(UIButton *)sender {
	int requestCount = 0;
	__block int successCount = 0;
	__block int faildCount = 0;
	for (BSUserMO *user in _usersCurrent) {
		if (!user.is_followingValue && user.is_publicValue && !user.local_is_sending_follow_requestValue) {
			user.local_is_sending_follow_requestValue = YES;
			
			sender.enabled = NO;
			requestCount++;
			
			BSUserPublicFollowHttpRequest *request = [BSUserPublicFollowHttpRequest request];
			request.user_id = user.identifierValue;
			[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
				user.local_is_sending_follow_requestValue = NO;
				user.is_followingValue = YES;
				[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:user];
				
				successCount++;
				if ((successCount + faildCount) == requestCount) {
					sender.enabled = YES;
				}
				if (successCount == requestCount) {
					[self _showHeaderView:NO];
					[BSUIGlobal showMessage:ZPLocalizedString(@"Followed")];
				}
			} failedBlock:^(BSHttpResponseDataModel *result) {
				user.local_is_sending_follow_requestValue = NO;
				faildCount++;
				if ((successCount + faildCount) == requestCount) {
					sender.enabled = YES;
				}
			}];
		}
	}
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _usersCurrent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSFollowPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSFollowPeopleTableViewCell" forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	BSUserMO *user = [_usersCurrent objectAtIndex:indexPath.row];
	[cell.btnAvatar configWithUser:user];
	cell.lblName.text = user.name_human_readable;
	cell.lblUserName.text = user.name_id;
	cell.user = user;
	[cell.btnFollow configWithUser:user];

	NSArray *highlightAry = [user.recent_highlights allObjects];
	NSMutableArray *tempAry = [NSMutableArray array];
	if (highlightAry.count > 3) {
		for (int i = 0; i < 3; i++) {
			[tempAry addObject:[highlightAry objectAtIndex:i]];
		}
	}

	cell.userHighlightAry = tempAry;

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 62.0;
}

@end
