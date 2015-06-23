//
//  BSExploreEventTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreEventTableViewDataSource.h"
#import "BSExploreEventsHttpRequest.h"
#import "BSEventsDataModel.h"
#import "BSProfileViewController.h"

@implementation BSExploreEventTableViewDataSource

- (id)init {
	self = [super init];
	if (self) {
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSExploreEventsHttpRequest *request = [BSExploreEventsHttpRequest request];
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		BSTableViewSectionDataModel *eventsDM = [BSTableViewSectionDataModel dataModelWithSectionTitle:nil rowsDataModel:((BSEventsDataModel *)result.dataModel).events];
		_dataModel = [BSTableViewDataSourceDataModel dataModelWithSections:@[eventsDM]];
		
		[_tableView reloadData];
		
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
	    ZPInvokeBlock(faild, result.error);
	}];
}

@end
