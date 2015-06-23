//
//  BSLikeOrInviteButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLikeOrInviteButton.h"
#import "BSLikeOrInviteButtonFollowedView.h"
#import "BSDataModels.h"
#import "BSDataManager.h"
#import "BSUtility.h"

#import "BSTeamSettingsViewController.h"

#import "BSUserPublicFollowHttpRequest.h"
#import "BSUserPrivateFollowHttpRequest.h"
#import "BSUserUnfollowHttpRequest.h"

#import "BSTeamFollowHttpRequest.h"
#import "BSTeamUnfollowHttpRequest.h"
#import "BSTeamInviteMemberHttpRequest.h"

#import "BSEventFollowHttpRequest.h"
#import "BSEventUnfollowHttpRequest.h"

#import "UIControl+EventTrack.h"

typedef NS_ENUM(NSInteger, BSLikeOrInviteButtonDataType) {
	BSLikeOrInviteButtonDataTypeNone,
	BSLikeOrInviteButtonDataTypeFollow,
	BSLikeOrInviteButtonDataTypeInvite
};

@interface BSLikeOrInviteButton()
{
	ZPVoidBlock _btnSettingOrFollowActionBlock;
}

@property (nonatomic, strong) id data;
@property (nonatomic, strong) BSLikeOrInviteButtonFollowedView *followedAnimationView;

@end

@implementation BSLikeOrInviteButton

- (void)_commitInit {
	static UILabel *titleLable = nil;
	if (!titleLable) {
		titleLable = self.followedAnimationView.titleLabel;
	}
	
    self.clipsToBounds = NO;
//	self.titleLabel.minimumScaleFactor = .7;
	self.titleLabel.adjustsFontSizeToFitWidth = YES;
	self.titleLabel.font = titleLable.font;
	[self setTitle:nil forState:UIControlStateNormal];
	[self setTitleColor:titleLable.textColor forState:UIControlStateNormal];
	
	self.followedAnimationView.alpha = 0;
	[self addTarget:self action:@selector(_tapped) forControlEvents:UIControlEventTouchUpInside];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self _commitInit];
}

- (void)dealloc {
	[self _removeObserver];
}

- (UIButton *)followedAnimationView {
    if (!_followedAnimationView) {
        _followedAnimationView = [[UINib nibWithNibName:@"BSLikeOrInviteButtonFollowedView" bundle:nil] instantiateWithOwner:nil options:nil][0];
        [self addSubview:_followedAnimationView];
    }
    return _followedAnimationView;
}

- (void)_addObserver {
	if (_data) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_followStateDidChanged:) name:kFollowStateDidChangedNotification object:_data];
	}
}

- (void)_removeObserver {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kFollowStateDidChangedNotification object:_data];
}

- (void)_followStateDidChanged:(NSNotification *)notification {
	if (notification.object == _data) {
		[self _refreshUI];
	}
}

- (NSString *)_getImageBGNameEnabled:(BOOL)enabled {
	if (enabled) {
		return _showBackgroundImage ? @"common_buttoncircle_enabled" : nil;
	} else {
		return _showBackgroundImage ? @"common_buttoncircle_disabled" : nil;
	}
}

- (void)_playFollowedAnimation {
    self.followedAnimationView.hidden = NO;
    self.followedAnimationView.alpha = 0;
    self.followedAnimationView.top = self.height;
    self.followedAnimationView.right = self.width;
	
    [UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.followedAnimationView.alpha = 1;
        self.followedAnimationView.centerY = self.height / 2;
		self.imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDefaultAnimateDuration delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.followedAnimationView.alpha = 0;
            self.followedAnimationView.bottom = 0;
			self.imageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.followedAnimationView.hidden = YES;
        }];
    }];
}

- (void)_tapped {
	ZPInvokeBlock(_btnSettingOrFollowActionBlock);
}

- (void)_toggleUserFollowing {
	BSUserMO *user = self.data;
	BOOL originFollowing = user.is_followingValue;
	ZPVoidBlock postRequest = ^ {
		BOOL isPrivateFollow = NO;
		BSUserBaseHttpRequest *request;
		if (originFollowing) {
			request = [BSUserUnfollowHttpRequest request];
		}
		else {
			if (user.is_publicValue) {
				request = [BSUserPublicFollowHttpRequest request];
			} else {
				request = [BSUserPrivateFollowHttpRequest request];
				isPrivateFollow = YES;
			}
		}
		request.user_id = user.identifierValue;
		[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			if (!originFollowing) {
				if (isPrivateFollow) {
					[[BSDataManager sharedInstance].currentUser.pendingUsers addObject:user];
					[self _refreshUI];
				} else {
					[self _playFollowedAnimation];
				}
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:user];
		} failedBlock: ^(BSHttpResponseDataModel *result) {
			if (!isPrivateFollow) {
				user.is_followingValue = originFollowing;
				[self _refreshUI];
			}
		}];
		if (!isPrivateFollow) {
			user.is_followingValue = !originFollowing;
			[self _refreshUI];
		}
	};
	
	if (originFollowing) {
		[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Stop following this user?") isDestructive:YES actionTitle:ZPLocalizedString(@"Stop following") actionHandler:^{
			postRequest();
		}];
	} else {
		if (!user.is_publicValue) {
			[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Privacy user following message") isDestructive:YES actionTitle:ZPLocalizedString(@"Apply to Follow") actionHandler:^{
				postRequest();
			}];
		} else {
			postRequest();
		}
	}
}

- (void)_toggleTeamFollowing {
	BSTeamMO *team = self.data;
	BOOL originFollowing = team.is_followingValue;
	ZPVoidBlock postRequest = ^ {
		BSTeamBaseHttpRequest *request;
		if (originFollowing) {
			request = [BSTeamUnfollowHttpRequest request];
		} else {
			request = [BSTeamFollowHttpRequest request];
		}
		request.teamId = team.identifierValue;
		[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			if (!originFollowing) {
				[self _playFollowedAnimation];
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:team];
		} failedBlock: ^(BSHttpResponseDataModel *result) {
			team.is_followingValue = originFollowing;
			[self _refreshUI];
		}];
		team.is_followingValue = !originFollowing;
		[self _refreshUI];
	};
	
	if (originFollowing) {
		[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Stop following this team?") isDestructive:YES actionTitle:ZPLocalizedString(@"Stop following") actionHandler:^{
			postRequest();
		}];
	} else {
		// if team is private, it is not visible to tap
		postRequest();
	}
}

- (void)_toggleEventFollowing {
	BSEventMO *event = self.data;
	BOOL originFollowing = event.is_followingValue;
	ZPVoidBlock postRequest = ^ {
		BSEventBaseHttpRequest *request;
		if (originFollowing) {
			request = [BSEventUnfollowHttpRequest request];
		}
		else {
			request = [BSEventFollowHttpRequest request];
		}
		request.eventId = event.identifierValue;
		[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			if (!originFollowing) {
				[self _playFollowedAnimation];
				
				event.is_followingValue = YES;
				[self _refreshUI];// make sure to set it again to avoid other apis return NO
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:event];
		} failedBlock: ^(BSHttpResponseDataModel *result) {
			event.is_followingValue = originFollowing;
			[self _refreshUI];
		}];
		event.is_followingValue = !originFollowing;
		[self _refreshUI];
	};
	
	if (originFollowing) {
		[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"Stop following this event?") isDestructive:YES actionTitle:ZPLocalizedString(@"Stop following") actionHandler:^{
			postRequest();
		}];
	} else {
		postRequest();
	}
}

- (void)setData:(id)data {
	if (_data != data) {
		[self _removeObserver];
		_data = data;
		[self _addObserver];
	}
}

- (void)configWithUser:(BSUserMO *)user {
	self.data = user;
	
	BOOL hidden = NO;
	BOOL enabled = YES;
	NSString *imgName = nil, *imgBGName = nil, *title = nil;
	
	if (user == [BSDataManager sharedInstance].currentUser) {
		imgName = @"profile_edit_icon";
		imgBGName = [self _getImageBGNameEnabled:YES];
		self.eventTrackName = @"options";
		_btnSettingOrFollowActionBlock = ^{
			UIViewController *vc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileOptionsViewController"];
			[BSUtility pushViewController:vc];
		};
	} else {
		if (user.is_following == nil) {
			hidden = YES;
		} else if (user.is_followingValue) {
			imgName = @"profile_followed_icon";
			imgBGName = [self _getImageBGNameEnabled:NO];
			enabled = _enableAfterFollowed;
			self.eventTrackName = @"follow_user";
		}
		else {
			if (!user.is_publicValue && [[BSDataManager sharedInstance].currentUser.pendingUsers containsObject:user]) {
				title = ZPLocalizedString(@"REQUESTED");
				enabled = _enableAfterFollowed;
			} else {
				imgName = user.is_publicValue ? @"profile_addfriend_icon" : @"profile_followprivateuser_icon";
				imgBGName = [self _getImageBGNameEnabled:YES];
				self.eventTrackName = @"request_follow_user";
			}
		}
		__weak typeof(self) weakSelf = self;
		_btnSettingOrFollowActionBlock = ^{
			[weakSelf _toggleUserFollowing];
		};
	}
	
	self.hidden = hidden;
	self.enabled = enabled;
	[self setTitle:title forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:imgBGName] forState:UIControlStateNormal];
}

- (void)configWithTeam:(BSTeamMO *)team {
	self.data = team;
	
	BOOL hidden = NO;
	BOOL enabled = YES;
	NSString *imgName = nil, *imgBGName = nil, *title = nil;
	
	if (/*team.is_manager == nil || */team.is_member == nil || team.is_following == nil || team.is_private == nil) {
		hidden = YES;
	} else if (team.is_managerValue || team.is_memberValue || team.is_followingValue || !team.is_privateValue) {
		__weak typeof(self) weakSelf = self;
		
		if (team.is_managerValue || team.is_memberValue) {
			if (_showBackgroundImage) {
				imgName = @"profile_edit_icon";
				imgBGName = [self _getImageBGNameEnabled:YES];
			} else {
				title = ZPLocalizedString(@"Joined");
				enabled = _enableAfterFollowed;
			}
			_btnSettingOrFollowActionBlock = ^{
				BSTeamSettingsViewController *vc = [BSTeamSettingsViewController instanceFromStoryboard];
				vc.team = team;
				[BSUtility pushViewController:vc];
			};
			self.eventTrackName = @"team_settings";
		} else {
			if (team.is_followingValue) {
				imgName = @"profile_teamfollowed_icon";
				imgBGName = [self _getImageBGNameEnabled:NO];
				enabled = _enableAfterFollowed;
				self.eventTrackName = @"unfollow_team";
			} else {
				imgName = @"profile_followteam_icon";
				imgBGName = [self _getImageBGNameEnabled:YES];
				self.eventTrackName = @"follow_team";
			}
			_btnSettingOrFollowActionBlock = ^{
				[weakSelf _toggleTeamFollowing];
			};
		}
	} else {
		hidden = YES;
	}
	
	self.hidden = hidden;
	self.enabled = enabled;
	[self setTitle:title forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:imgBGName] forState:UIControlStateNormal];
}

- (void)configWithEvent:(BSEventMO *)event {
	self.data = event;
	
	BOOL hidden = NO;
	BOOL enabled = YES;
	NSString *imgName = nil, *imgBGName = nil, *title = nil;
	
	if (event.is_following == nil) {
		hidden = YES;
	} else if (event.is_followingValue) {
		imgName = @"profile_eventfollowed_icon";
		imgBGName = [self _getImageBGNameEnabled:NO];
		enabled = _enableAfterFollowed;
		self.eventTrackName = @"unfollow_event";
	} else {
		imgName = @"profile_followevent_icon";
		imgBGName = [self _getImageBGNameEnabled:YES];
		self.eventTrackName = @"follow_event";
	}
	
	__weak typeof(self) weakSelf = self;
	_btnSettingOrFollowActionBlock = ^{
		[weakSelf _toggleEventFollowing];
	};
	
	self.hidden = hidden;
	self.enabled = enabled;
	[self setTitle:title forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:imgBGName] forState:UIControlStateNormal];
}

- (void)configWithInviteUser:(BSUserMO *)user ofTeam:(BSTeamMO *)team {
	ZPVoidBlock _refreshUIForInvitation = ^ {
		BOOL hidden = NO;
		BOOL enabled = YES;
		NSString *imgName = nil, *imgBGName = nil, *title = nil;
		
		if (team.members && [team.members containsObject:user]) {
			title = ZPLocalizedString(@"Joined");
			enabled = _enableAfterFollowed;
		} else if (team.pendingUsers && [team.pendingUsers containsObject:user]) {
			title = ZPLocalizedString(@"Invited");
			enabled = _enableAfterFollowed;
		} else {
			imgName = @"common_radiobutton";
			self.eventTrackName = @"invite_user";
			self.eventTrackProperties = @{@"team_id":team.identifier, @"user_id":user.identifier};
		}
		
		self.hidden = hidden;
		self.enabled = enabled;
		[self setTitle:title forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:imgBGName] forState:UIControlStateNormal];
	};
	ZPInvokeBlock(_refreshUIForInvitation);
	
	_btnSettingOrFollowActionBlock = ^{
		[team.pendingUsers addObject:user];
		ZPInvokeBlock(_refreshUIForInvitation);
		
		BSTeamInviteMemberHttpRequest *request = [BSTeamInviteMemberHttpRequest request];
		request.teamId = team.identifierValue;
		request.userId = user.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		} failedBlock:^(BSHttpResponseDataModel *result) {
			[team.pendingUsers removeObject:user];
			ZPInvokeBlock(_refreshUIForInvitation);
		}];
	};
}

- (void)setShowBackgroundImage:(BOOL)showBackgroundImage {
	if (_showBackgroundImage != showBackgroundImage) {
		_showBackgroundImage = showBackgroundImage;
		[self _refreshUI];
	}
}

- (void)setEnableAfterFollowed:(BOOL)enableAfterFollowed {
	if (_enableAfterFollowed != enableAfterFollowed) {
		_enableAfterFollowed = enableAfterFollowed;
		[self _refreshUI];
	}
}

- (void)_refreshUI {
	if ([_data isKindOfClass:[BSUserMO class]]) {
		[self configWithUser:_data];
	} else if ([_data isKindOfClass:[BSTeamMO class]]) {
		[self configWithTeam:_data];
	} else if ([_data isKindOfClass:[BSEventMO class]]) {
		[self configWithEvent:_data];
	}
}

- (NSDictionary *) eventTrackProperties {
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:[super eventTrackProperties]];

	if ([_data isKindOfClass:[BSUserMO class]]) {
		BSUserMO *user = (BSUserMO *)_data;
		[properties setObject:user.identifier forKey:@"user_id"];
		[properties setObject:user.is_following ? @"yes":@"no" forKey:@"following"];
	} else if ([_data isKindOfClass:[BSTeamMO class]]) {
		BSTeamMO *team = (BSTeamMO *)_data;
		[properties setObject:team.identifier forKey:@"team_id"];
		[properties setObject:team.members_count forKey:@"team_members"];
	} else if ([_data isKindOfClass:[BSEventMO class]]) {
		BSEventMO *event = (BSEventMO *)_data;
		[properties setObject:event.identifier forKey:@"event_id"];
		[properties setObject:@(event.followers.count) forKey:@"event_friends"];
	}
	
	return properties;
}

@end
