//
//  BSTeamInviteUserTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 3/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInviteTableViewDataSource.h"

#import "BSLikeTableViewCell.h"
#import "BSUIGlobal.h"

#import "BSDataManager.h"
#import "BSUserMO.h"
#import "BSTeamMO.h"
#import "BSUsersDataModel.h"

#import "BSExploreSearchPeopleHttpRequest.h"
#import "BSUserFollowersHttpRequest.h"
#import "BSUserFollowingHttpRequest.h"
#import "BSTeamInviteEmailHttpRequest.h"

#import "BSEventTracker.h"

@implementation BSTeamInviteTableViewDataSource
- (instancetype) initWithTeam:(BSTeamMO *)team {
	if (self = [super init]) {
		_team = team;
	}
	
	return self;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLikeTableViewCell.className forIndexPath:indexPath];
	
	BSUserMO *user = _users[indexPath.row];
	[cell.btnAvatar configWithUser:user];
	cell.lblStyle1Title.text = user.name_human_readable;
	cell.lblStyle1SubTitle.text = user.name_id;
	
	[cell.btnLikeInvite configWithInviteUser:user ofTeam:_team];
	return cell;
}
@end


@interface BSTeamInviteFriendsTableViewDataSource()
{
	NSArray *_followers;
	NSArray *_followings;
}
@end


@implementation BSTeamInviteFriendsTableViewDataSource

+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team {
	return [[[self class] alloc] initWithTeam:team];
}

- (instancetype) initWithTeam:(BSTeamMO *)team {
	if (self = [super initWithTeam:team]) {
		BSUserMO *me = [BSDataManager sharedInstance].currentUser;
		
		BSUserFollowersHttpRequest *followersRequest = [BSUserFollowersHttpRequest request];
		followersRequest.user_id = me.identifierValue;
		[followersRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			_followers = ((BSUsersDataModel *)result.dataModel).users;
			[self _updateFriends];
		} failedBlock:nil];
		
		BSUserFollowingHttpRequest *followingRequest = [BSUserFollowingHttpRequest request];
		followingRequest.user_id = me.identifierValue;
		[followingRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			_followings = ((BSUsersDataModel *)result.dataModel).users;
			[self _updateFriends];
		} failedBlock:nil];
	}
	
	return self;
}

- (void) _updateFriends {
	if (!_followers || !_followings) {
		return;
	}
	
	NSMutableSet *userSet = [NSMutableSet setWithArray:_followers];
	[userSet intersectSet:[NSSet setWithArray:_followings]];
	_users = [userSet sortedArrayWithKey:@"name_id" ascending:YES];
	[_tableView reloadData];
}
@end



@interface BSTeamInviteSearchPeopleTableViewDataSource ()
{
	@protected
	BSExploreSearchPeopleHttpRequest *_request;
}
@end

@implementation BSTeamInviteSearchPeopleTableViewDataSource
+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team {
	return [[[self class] alloc] initWithTeam:team];
}

- (void) clearData {
	_users = nil;
	[_tableView reloadData];
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (_request) {
		[_request cancelRequest];
		_request = nil;
	}
	
	if (!self.keyword || self.keyword.length == 0) {
		[self clearData];
		[_tableView reloadData];
		
		ZPInvokeBlock(success);
		return;
	}
	
	_request = [BSExploreSearchPeopleHttpRequest request];
	_request.keyword = self.keyword;
	
	BSExploreSearchPeopleHttpRequest *request = _request;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (request == _request) {
			[BSEventTracker trackAction:@"search" page:nil properties:@{@"search_string":request.keyword, @"team_id":_team.identifier}];

			[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
				if (request != _request) {
					return;
				}
				_request = nil;
				
				_users = ((BSUsersDataModel *)result.dataModel).users;
				[_tableView reloadData];
				
				ZPInvokeBlock(success);
			} failedBlock:^(BSHttpResponseDataModel *result) {
				if (request != _request) {
					return;
				}
				_request = nil;
				ZPInvokeBlock(faild, result.error);
			}];
		}
	});
}

@end



#define MIN_EMAIL_COUNT 3

@interface BSTeamInviteEmailTableViewDataSource() <BSEmailFieldTableViewCellDelegate>
@end

@implementation BSTeamInviteEmailTableViewDataSource
{
	NSMutableArray *_emails;
}

+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team {
	return [[[self class] alloc] initWithTeam:team];
}

- (instancetype) initWithTeam:(BSTeamMO *)team {
	if (self = [super initWithTeam:team]) {
		_emails = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) submitWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	[BSEventTracker trackTap:@"invite_email" page:nil properties:@{@"team_id":_team.identifier, @"emails":@(_emails.count)}];
	
	if (_emails.count > 0) {
		for (NSString *email in _emails) {
			if (![email isValidEmail]) {
				ZPInvokeBlock(faild, nil);
				return;
			}
		}

		BSTeamInviteEmailHttpRequest *request = [BSTeamInviteEmailHttpRequest request];
		request.teamId = _team.identifierValue;
		request.emails = [NSSet setWithArray:_emails].allObjects;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			ZPInvokeBlock(success);
			[_emails removeAllObjects];
			[_tableView reloadData];
			if (self.delegate) {
				[self.delegate dataSource:self didChangeSubmittable:NO];
			}
		} failedBlock:^(BSHttpResponseDataModel *result) {
			ZPInvokeBlock(faild, result.error);
		}];
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			ZPInvokeBlock(success);
			if (self.delegate) {
				[self.delegate dataSource:self didChangeSubmittable:NO];
			}
		});
	}
}

- (void) _tryEditRow:(NSInteger)row {
	if (row > _emails.count) {
		row = _emails.count;
	}
	BSEmailFieldTableViewCell *cell = (BSEmailFieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
	[cell beginEditing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	_tableView = tableView;
	return MAX(MIN_EMAIL_COUNT, _emails.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSEmailFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSEmailFieldTableViewCell.className forIndexPath:indexPath];
	[cell configureRow:indexPath.row email:(indexPath.row < _emails.count ? _emails[indexPath.row] : nil)];
	cell.delegate = self;
	return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self _tryEditRow:indexPath.row];
}

#pragma mark - BSEmailFieldTableViewCellDelegate
- (void) rowDidBeginEditing:(NSInteger)row {
	if (row > _emails.count) {
		[self _tryEditRow:row];
	} else {
		// already in editing
	}
}

- (void) row:(NSInteger)row didInputEmail:(NSString *)email {
	BOOL valid = YES;
	
	if (email && email.length > 0) {
		if (row < _emails.count) {
			[_emails replaceObjectAtIndex:row withObject:email];
		} else {
			[_emails addObject:email];
			if (_emails.count >= MIN_EMAIL_COUNT) {
				[_tableView beginUpdates];
				[_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_emails.count inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
				[_tableView endUpdates];
			}
		}
		
		if (![email isValidEmail]) {
			valid = NO;
		}
	} else if (row < _emails.count) {
		[_emails removeObjectAtIndex:row];
		if (_emails.count + 1 >= MIN_EMAIL_COUNT) {
			[_tableView beginUpdates];
			[_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
			[_tableView endUpdates];
		}
	}
	
	if (valid && _emails.count > 0) {
		for (NSString *email in _emails) {
			if (![email isValidEmail]) {
				valid = NO;
				break;
			}
		}
	}
	
	if (self.delegate) {
		[self.delegate dataSource:self didChangeSubmittable:valid];
	}
}

@end