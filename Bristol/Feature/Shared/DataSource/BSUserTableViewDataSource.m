//
//  BSUserTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTableViewDataSource.h"
#import "BSLikeTableViewCell.h"
#import "BSProfileViewController.h"
#import "BSEventTracker.h"

@implementation BSUserTableViewDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_tableView != tableView) {
		_tableView = tableView;
		[_tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	}
	return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLikeTableViewCell.className forIndexPath:indexPath];
	[cell configWithUser:_users[indexPath.row]];
	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSUserMO *user = (BSUserMO *)_users[indexPath.row];
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id":user.identifier, @"list_rank":@(indexPath.row+1), @"following":user.is_followingValue ? @"yes":@"no"}];
	if (self.eventTrackProperties) {
		[properties addEntriesFromDictionary:self.eventTrackProperties];
	}
	
	[BSEventTracker trackTap:@"user" page:nil properties:properties];
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:_users[indexPath.row]]];
}

@end
