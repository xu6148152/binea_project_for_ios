//
//  BSBaseTeamEventTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTeamEventTableViewDataSource.h"
#import "BSProfileTeamTableViewCell.h"
#import "BSProfileViewController.h"

#import "BSDataModels.h"

@implementation BSBaseTeamEventTableViewDataSource

+ (instancetype)dataSourceWithUser:(BSUserMO *)user {
	return [[[self class] alloc] initWithUserMO:user];
}

- (id)initWithUserMO:(BSUserMO *)user {
	NSParameterAssert([user isKindOfClass:[BSUserMO class]]);
	self = [super init];
	if (self) {
		_user = user;
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (_tableView != tableView) {
		_tableView = tableView;
		
		[_tableView registerNib:[UINib nibWithNibName:BSProfileTeamTableViewCell.className bundle:nil] forCellReuseIdentifier:BSProfileTeamTableViewCell.className];
	}

	return _dataModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BSTableViewSectionDataModel *dm = _dataModel.sections[section];
	return dm.rowsDataModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	BSTableViewSectionDataModel *dm = _dataModel.sections[section];
	if (dm.sectionTitle.length > 0) {
		return dm.rowsDataModel.count > 0 ? 22 : 0;
	} else {
		return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BSTableViewSectionDataModel *dm = _dataModel.sections[section];
	return [BSUIGlobal createCommonTableViewSectionHeaderWithTitle:dm.sectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSProfileTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSProfileTeamTableViewCell.className forIndexPath:indexPath];
	BSTableViewSectionDataModel *dm = _dataModel.sections[indexPath.section];
	cell.eventTrackProperties = @{@"list_rank":@(indexPath.row+1)};
	[cell configWithData:dm.rowsDataModel[indexPath.row]];
	return cell;
}

#pragma - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSTableViewSectionDataModel *dm = _dataModel.sections[indexPath.section];
	BSTeamMO *team = dm.rowsDataModel[indexPath.row]; // maybe BSTeamMO or BSEventMO
	BOOL hasHighlights = team.highlights.count > 0 || team.recent_highlights.count > 0;
	return 103 + (hasHighlights ? (tableView.width - (kHighlightCellColumnCount - 1)) / kHighlightCellColumnCount : 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id model = ((BSTableViewSectionDataModel *)_dataModel.sections[indexPath.section]).rowsDataModel[indexPath.row];

	if ([model isKindOfClass:[BSTeamMO class]]) {
		BSTeamMO *team = (BSTeamMO *)model;
		[BSEventTracker trackTap:@"team" page:nil properties:@{@"team_id":team.identifier, @"list_rank":@(indexPath.row+1), @"team_members":team.members_count}];
	} else if ([model isKindOfClass:[BSEventMO class]]){
		BSEventMO *event = (BSEventMO *)model;
		[BSEventTracker trackTap:@"event" page:nil properties:@{@"event_id":event.identifier, @"list_rank":@(indexPath.row+1), @"event_friends":@(event.followers.count)}];
	}
	
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithModel:model]];
}

@end
