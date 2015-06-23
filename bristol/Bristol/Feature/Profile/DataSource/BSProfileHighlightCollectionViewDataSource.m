//
//  BSProfileHighlightCollectionViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileHighlightCollectionViewDataSource.h"
#import "BSUserHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"
#import "BSProfileHighlightCollectionViewCell.h"
#import "BSFeedViewController.h"

@implementation BSProfileHighlightCollectionViewDataSource
{
	BSUserHighlightsHttpRequest *_requestRefresh;
}

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

- (BOOL)postNewHighlight:(BSHighlightMO *)highlight {
	if (![_highlights containsObject:highlight]) {
		[_highlights insertObject:highlight atIndex:0];
		[_collectionView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)removeHighlight:(BSHighlightMO *)highlight {
	if ([_highlights containsObject:highlight]) {
		[_highlights removeObject:highlight];
		[_collectionView reloadData];
		return YES;
	} else {
		return NO;
	}
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (!_user) {
		return;
	}
	
	_requestRefresh = [BSUserHighlightsHttpRequest request];
	_requestRefresh.user_id = self.user.identifierValue;
	_requestRefresh.startIndex = 0;
	NSUInteger countInOnePage = _requestRefresh.countInOnePage;
	[_requestRefresh postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
	    _highlights = [((BSHighlightsDataModel *)result.dataModel).highlights mutableCopy];
		_isNoMoreData = _highlights.count < countInOnePage;

		[_collectionView reloadData];
		ZPInvokeBlock(success);
		_requestRefresh = nil;
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
		_requestRefresh = nil;
	}];
}

- (BSCustomHttpRequest *)getNewLoadMoreDataHttpRequest {
	if (_requestRefresh) {
		return nil;
	}
	BSUserHighlightsHttpRequest *request = [BSUserHighlightsHttpRequest request];
	request.user_id = self.user.identifierValue;
	request.startIndex = _highlights.count;

	return request;
}

@end
