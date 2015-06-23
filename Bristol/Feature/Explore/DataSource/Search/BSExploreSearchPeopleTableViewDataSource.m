//
//  BSExploreSearchPeopleTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchPeopleTableViewDataSource.h"
#import "BSExploreSearchPeopleHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSLikeTableViewCell.h"
#import "BSProfileViewController.h"


@implementation BSExploreSearchPeopleTableViewDataSource
{
	NSArray *_users;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_tableView != tableView) {
		_tableView = tableView;
		
		[_tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	}
	return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLikeTableViewCell.className forIndexPath:indexPath];
	cell.cellStyle = BSLikeTableViewCellStyle1;
	cell.eventTrackProperties = @{@"list_rank":@(indexPath.row+1)};
	[cell configWithUser:_users[indexPath.row]];
	return cell;
}

#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSUserMO *user = _users[indexPath.row];
	[BSEventTracker trackTap:@"user" page:nil properties:@{@"list_rank":@(indexPath.row+1), @"user_id":user.identifier}];
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:user]];
}

#pragma - BSExploreSearchTableViewDataSource
- (void)clearData {
	_users = nil;
}

- (BSExploreSearchHttpRequest *)prepareRequest {
	return [BSExploreSearchPeopleHttpRequest request];
}

- (void)onRequestSucceeded:(BSHttpResponseDataModel *)result {
	_users = ((BSUsersDataModel *)result.dataModel).users;
}

@end
