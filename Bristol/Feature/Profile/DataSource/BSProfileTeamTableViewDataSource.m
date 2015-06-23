//
//  BSProfileTeamTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileTeamTableViewDataSource.h"
#import "BSUserTeamsHttpRequest.h"
#import "BSUserTeamsDataModel.h"
#import "BSProfileTeamTableViewCell.h"
#import "BSProfileViewController.h"

@implementation BSProfileTeamTableViewDataSource

- (BOOL)_addTeam:(BSTeamMO *)team toSection:(BSTableViewSectionDataModel *)section {
	if (!team || !section) {
		return NO;
	}
	
	if (![section.rowsDataModel containsObject:team]) {
		NSMutableArray *ary = [NSMutableArray arrayWithArray:section.rowsDataModel];
		[ary insertObject:team atIndex:0];
		section.rowsDataModel = ary;
		
		[_tableView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)_removeTeam:(BSTeamMO *)team fromSection:(BSTableViewSectionDataModel *)section {
	if (!team || !section) {
		return NO;
	}
	
	if ([section.rowsDataModel containsObject:team]) {
		NSMutableArray *ary = [NSMutableArray arrayWithArray:section.rowsDataModel];
		[ary removeObject:team];
		section.rowsDataModel = ary;
		
		[_tableView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)addFollowedTeam:(BSTeamMO *)team {
	return [self _addTeam:team toSection:_dataModel.sections[1]];
}

- (BOOL)removeFollowedTeam:(BSTeamMO *)team {
	return [self _removeTeam:team fromSection:_dataModel.sections[1]];
}

- (BOOL)addJoinedTeam:(BSTeamMO *)team {
	return [self _addTeam:team toSection:_dataModel.sections[0]];
}

- (BOOL)removeJoinedTeam:(BSTeamMO *)team {
	return [self _removeTeam:team fromSection:_dataModel.sections[0]];
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSUserTeamsHttpRequest *request = [BSUserTeamsHttpRequest request];
	request.user_id = self.user.identifierValue;
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		BSUserTeamsDataModel *dm = (BSUserTeamsDataModel *)result.dataModel;
		
		BSTableViewSectionDataModel *teamsJoined = [BSTableViewSectionDataModel dataModelWithSectionTitle:ZPLocalizedString(@"Joined") rowsDataModel:dm.joinedTeams];
		BSTableViewSectionDataModel *teamsFollowed = [BSTableViewSectionDataModel dataModelWithSectionTitle:ZPLocalizedString(@"Followed") rowsDataModel:dm.followedTeams];
		_dataModel = [BSTableViewDataSourceDataModel dataModelWithSections:@[teamsJoined, teamsFollowed]];
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSProfileTeamTableViewCell *cell = (BSProfileTeamTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.btnFollow.hidden = YES;
	
	return cell;
}

@end
