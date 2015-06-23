//
//  BSExploreSearchTeamTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchTeamTableViewDataSource.h"
#import "BSExploreSearchTeamsHttpRequest.h"
#import "BSTeamsDataModel.h"
#import "BSBaseTableViewCell.h"
#import "BSTeamMO.h"
#import "BSLikeTableViewCell.h"
#import "BSProfileViewController.h"


@implementation BSExploreSearchTeamTableViewDataSource
{
	NSArray *_teams;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_tableView != tableView) {
		_tableView = tableView;
		
		[_tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	}
	return _teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSLikeTableViewCell.className forIndexPath:indexPath];
	cell.cellStyle = BSLikeTableViewCellStyle2;
	cell.eventTrackProperties = @{@"list_rank":@(indexPath.row+1)};
	[cell configWithTeam:_teams[indexPath.row]];
	return cell;
}

#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSTeamMO *team = _teams[indexPath.row];
	[BSEventTracker trackTap:@"team" page:nil properties:@{@"list_rank":@(indexPath.row+1), @"team_id":team.identifier, @"team_members":team.members_count}];
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithTeam:team]];
}

#pragma - BSExploreSearchTableViewDataSource
- (void)clearData {
	_teams = nil;
}

- (BSExploreSearchHttpRequest *)prepareRequest {
	return [BSExploreSearchTeamsHttpRequest request];
}

- (void)onRequestSucceeded:(BSHttpResponseDataModel *)result {
	_teams = ((BSTeamsDataModel *)result.dataModel).teams;
}

@end
