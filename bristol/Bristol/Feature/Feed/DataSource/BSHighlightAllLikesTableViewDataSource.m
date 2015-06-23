//
//  BSHighlightAllLikesTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightAllLikesTableViewDataSource.h"
#import "BSHighlightAllLikesHttpRequest.h"
#import "BSDataModels.h"

@implementation BSHighlightAllLikesTableViewDataSource
{
	BSHighlightMO *_highlight;
}

+ (instancetype)dataSourceWithHighlight:(BSHighlightMO *)highlight {
	return [[[self class] alloc] initWithHighlight:highlight];
}

- (id)initWithHighlight:(BSHighlightMO *)highlight {
	if (self = [super init]) {
		_highlight = highlight;
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSHighlightAllLikesHttpRequest *request = [BSHighlightAllLikesHttpRequest request];
	request.highlightId = _highlight.identifierValue;
	request.lastUserId = 0;
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		_users = ((BSUsersDataModel *)result.dataModel).users;
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock:^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

@end
