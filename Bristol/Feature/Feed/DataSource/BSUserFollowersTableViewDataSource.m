//
//  BSUserFollowersTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserFollowersTableViewDataSource.h"
#import "BSUserFollowersHttpRequest.h"
#import "BSDataModels.h"

@implementation BSUserFollowersTableViewDataSource
{
	BSUserMO *_user;
}

+ (instancetype)dataSourceWithUser:(BSUserMO *)user {
	return [[BSUserFollowersTableViewDataSource alloc] initWithUser:user];
}

- (id)initWithUser:(BSUserMO *)user {
	if (self = [super init]) {
		_user = user;
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSUserFollowersHttpRequest *request = [BSUserFollowersHttpRequest request];
	request.user_id = _user.identifierValue;
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		_users = ((BSUsersDataModel *)result.dataModel).users;
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock:^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

@end
