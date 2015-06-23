//
//  BSProfileHighlightCollectionViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightLoadingMoreCollectionViewDataSource.h"
#import "BSUserMO.h"

@interface BSProfileHighlightCollectionViewDataSource : BSHighlightLoadingMoreCollectionViewDataSource

+ (instancetype)dataSourceWithUser:(BSUserMO *)user;

@property (nonatomic, strong, readonly) BSUserMO *user;

- (BOOL)postNewHighlight:(BSHighlightMO *)highlight;
- (BOOL)removeHighlight:(BSHighlightMO *)highlight;

@end
