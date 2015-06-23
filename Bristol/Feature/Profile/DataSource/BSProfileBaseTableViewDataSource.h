//
//  BSBaseTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSBaseTableViewDataSource.h"
#import "BSUserMO.h"

@interface BSProfileBaseTableViewDataSource : BSBaseTableViewDataSource

@property (nonatomic, strong, readonly) BSUserMO *user;

+ (instancetype)dataSourceWithUser:(BSUserMO *)user;

- (id)initWithUserMO:(BSUserMO *)user;

@end
