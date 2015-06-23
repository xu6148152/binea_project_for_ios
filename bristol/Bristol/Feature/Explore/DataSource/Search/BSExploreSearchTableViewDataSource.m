//
//  BSExploreSearchTableViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchTableViewDataSource.h"
#import "BSEventTracker.h"

@implementation BSExploreSearchTableViewDataSource

- (id)init {
	self = [super init];
	if (self) {
		[self refreshDataWithSuccess:NULL faild:NULL];
	}
	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (_request) {
		[_request cancelRequest];
		_request = nil;
	}

	if (!self.keyword || self.keyword.length == 0) {
		[self clearData];
		[_tableView reloadData];
		
		ZPInvokeBlock(success);
		return;
	}

	_request = [self prepareRequest];
	if (_request) {
		_request.keyword = self.keyword;
		BSExploreSearchHttpRequest *request = _request;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			if (request == _request) {
				[BSEventTracker trackAction:@"search" page:nil properties:@{@"search_string":request.keyword}];
			    [request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			        if (request != _request) {
			            return;
					}
			        _request = nil;
					
                    [self onRequestSucceeded:result];
					[_tableView reloadData];
					
			        ZPInvokeBlock(success);
				} failedBlock: ^(BSHttpResponseDataModel *result) {
			        if (request != _request) {
			            return;
					}
			        _request = nil;

					[_tableView reloadData];
					
			        ZPInvokeBlock(faild, result.error);
				}];
			}
		});
	}
}

#pragma - child implementation
- (void)clearData {
}

- (BSExploreSearchHttpRequest *)prepareRequest {
	return nil;
}

- (void)onRequestSucceeded:(BSHttpResponseDataModel *)result {
	
}

#pragma - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 63;
}

@end
