//
//  BSUserFollowersTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTableViewDataSource.h"

@class BSUserMO;

@interface BSUserFollowersTableViewDataSource : BSUserTableViewDataSource

+ (instancetype)dataSourceWithUser:(BSUserMO *)user;

@end
