//
//  BSHighlightLoadingMoreCollectionViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightCollectionViewDataSource.h"
#import "BSCustomHttpRequest.h"

@interface BSHighlightLoadingMoreCollectionViewDataSource : BSHighlightCollectionViewDataSource
{
	BOOL _isNoMoreData;
}

- (BSCustomHttpRequest *)getNewLoadMoreDataHttpRequest;

@end
