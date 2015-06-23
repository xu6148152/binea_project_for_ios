//
//  BSProfileEventTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileEventTableViewDataSource.h"
#import "BSUserEventsHttpRequest.h"
#import "BSEventsDataModel.h"
#import "BSProfileTeamTableViewCell.h"

@implementation BSProfileEventTableViewDataSource

- (BOOL)addFollowedEvent:(BSEventMO *)event {
	uint index = event.is_activeValue ? 0 : 1;
	BSTableViewSectionDataModel *eventsDM = _dataModel.sections[index];
	if (![eventsDM.rowsDataModel containsObject:event]) {
		NSMutableArray *ary = [NSMutableArray arrayWithArray:eventsDM.rowsDataModel];
		[ary insertObject:event atIndex:0];
		eventsDM.rowsDataModel = ary;
		
		[_tableView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)removeFollowedEvent:(BSEventMO *)event {
	uint index = event.is_activeValue ? 0 : 1;
	BSTableViewSectionDataModel *eventsDM = _dataModel.sections[index];
	if ([eventsDM.rowsDataModel containsObject:event]) {
		NSMutableArray *ary = [NSMutableArray arrayWithArray:eventsDM.rowsDataModel];
		[ary removeObject:event];
		eventsDM.rowsDataModel = ary;
		
		[_tableView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSUserEventsHttpRequest *request = [BSUserEventsHttpRequest request];
	request.user_id = self.user.identifierValue;
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		NSMutableArray *eventsExpired = [NSMutableArray array];
		NSMutableArray *eventsInProgress = [NSMutableArray array];
		NSArray *eventsAll = ((BSEventsDataModel *)result.dataModel).events;
		for (BSEventMO *event in eventsAll) {
			if (event.is_activeValue) {
				[eventsInProgress addObject:event];
			} else {
				[eventsExpired addObject:event];
			}
		}
		
		BSTableViewSectionDataModel *inProgressDM = [BSTableViewSectionDataModel dataModelWithSectionTitle:ZPLocalizedString(@"In Progress") rowsDataModel:eventsInProgress];
		BSTableViewSectionDataModel *expiredDM = [BSTableViewSectionDataModel dataModelWithSectionTitle:ZPLocalizedString(@"Expired") rowsDataModel:eventsExpired];
		_dataModel = [BSTableViewDataSourceDataModel dataModelWithSections:@[inProgressDM, expiredDM]];
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

@end
