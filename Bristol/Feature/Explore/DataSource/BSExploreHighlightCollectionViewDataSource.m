//
//  BSExploreHighlightCollectionViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreHighlightCollectionViewDataSource.h"
#import "BSExploreHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"

@implementation BSExploreHighlightCollectionViewDataSource

- (id)init {
	self = [super init];
	if (self) {
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSExploreHighlightsHttpRequest *request = [BSExploreHighlightsHttpRequest request];
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
	    _highlights = [((BSHighlightsDataModel *)result.dataModel).highlights mutableCopy];

	    if (_collectionView.dataSource == self) {
	        [_collectionView reloadData];
		}
	    ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
	    ZPInvokeBlock(faild, result.error);
	}];
}

@end
