//
//  BSTeamMemberTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamMemberTableViewDataSource.h"
#import "BSTeamAllMembersHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSTeamAllFollowersHttpRequest.h"
#import "BSEventAllFollowersHttpRequest.h"

@implementation BSTeamMemberTableViewDataSource
{
	BSTeamMO *_team;
}

+ (instancetype)dataSourceWithTeam:(BSTeamMO *)team {
	return [[[self class] alloc] initWithTeam:team];
}

- (id)initWithTeam:(BSTeamMO *)team {
	if (self = [super init]) {
		NSParameterAssert([team isKindOfClass:[BSTeamMO class]]);
		_team = team;
		self.eventTrackProperties = @{@"team_id":_team.identifier};
	}

	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSTeamAllMembersHttpRequest *request = [BSTeamAllMembersHttpRequest request];
	request.teamId = _team.identifierValue;
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		_users = ((BSMembersDataModel *)result.dataModel).users;
		if (_team.members) {
			[_team removeMembers:_team.members];
		}
		[_team addMembers:[NSSet setWithArray:_users]];
		_team.members_countValue = (int)_users.count;
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

@end


@implementation BSEventFollowersTableViewDataSource
{
	BSEventMO *_event;
}

+ (instancetype)dataSourceWithEvent:(BSEventMO *)event {
	return [[[self class] alloc] initWithEvent:event];
}

- (id)initWithEvent:(BSEventMO *)event {
	if (self = [super init]) {
		NSParameterAssert([event isKindOfClass:[BSEventMO class]]);
		_event = event;
		self.eventTrackProperties = @{@"event_id":_event.identifier};
	}

	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSEventAllFollowersHttpRequest *request = [BSEventAllFollowersHttpRequest request];
	request.eventId = _event.identifierValue;
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
	    _users = ((BSUsersDataModel *)result.dataModel).users;
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
	    ZPInvokeBlock(faild, result.error);
	}];
}

@end
