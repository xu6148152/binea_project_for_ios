//
//  BSExploreSearchTableViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewDataSource.h"
#import "BSExploreSearchHttpRequest.h"


@interface BSExploreSearchTableViewDataSource : BSBaseTableViewDataSource
{
	@protected
	BSExploreSearchHttpRequest *_request;
}

@property (nonatomic) NSString *keyword;

- (void)clearData;
- (BSExploreSearchHttpRequest *)prepareRequest;
- (void)onRequestSucceeded:(BSHttpResponseDataModel *)result;

@end
