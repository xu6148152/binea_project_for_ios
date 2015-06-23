//
//  BSExploreSearchEventTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchEventTableViewDataSource.h"
#import "BSExploreSearchEventsHttpRequest.h"
#import "BSEventsDataModel.h"
#import "BSEventMO.h"
#import "BSBaseTableViewCell.h"
#import "BSLikeTableViewCell.h"
#import "BSProfileViewController.h"


@implementation BSExploreSearchEventTableViewDataSource
{
	NSArray *_events;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_tableView != tableView) {
		_tableView = tableView;
		
		[_tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	}
	return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLikeTableViewCell.className forIndexPath:indexPath];
	cell.cellStyle = BSLikeTableViewCellStyle2;
	cell.eventTrackProperties = @{@"list_rank":@(indexPath.row+1)};
	[cell configWithEvent:_events[indexPath.row]];
	return cell;
}

#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSEventMO *event = (BSEventMO *)_events[indexPath.row];

	[BSEventTracker trackTap:@"user" page:nil properties:@{@"list_rank":@(indexPath.row+1), @"event_id":event.identifier, @"event_friends":@(event.followers.count)}];
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithEvent:event]];
}

#pragma - BSExploreSearchTableViewDataSource
- (void)clearData {
	_events = nil;
}

- (BSExploreSearchHttpRequest *)prepareRequest {
	return [BSExploreSearchEventsHttpRequest request];
}

- (void)onRequestSucceeded:(BSHttpResponseDataModel *)result {
	_events = ((BSEventsUserKeyDataModel *)result.dataModel).events;
}

@end
