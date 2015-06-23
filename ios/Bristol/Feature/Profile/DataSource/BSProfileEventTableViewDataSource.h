//
//  BSProfileEventTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTeamEventTableViewDataSource.h"

@interface BSProfileEventTableViewDataSource : BSBaseTeamEventTableViewDataSource

- (BOOL)addFollowedEvent:(BSEventMO *)event;
- (BOOL)removeFollowedEvent:(BSEventMO *)event;

@end
