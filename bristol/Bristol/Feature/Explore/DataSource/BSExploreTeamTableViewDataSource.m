//
//  BSExploreTeamTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreTeamTableViewDataSource.h"
#import "BSTeamsDataModel.h"
#import "BSExploreTeamsHttpRequest.h"
#import "BSProfileViewController.h"

@implementation BSExploreTeamTableViewDataSource

- (id)init {
	self = [super init];
	if (self) {
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSExploreTeamsHttpRequest *request = [BSExploreTeamsHttpRequest request];
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		BSTableViewSectionDataModel *teamsDM = [BSTableViewSectionDataModel dataModelWithSectionTitle:nil rowsDataModel:((BSTeamsDataModel *)result.dataModel).teams];
		_dataModel = [BSTableViewDataSourceDataModel dataModelWithSections:@[teamsDM]];
		
		[_tableView reloadData];
		
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
	    ZPInvokeBlock(faild, result.error);
	}];
}

@end
