//
//  BSProfileTeamTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTeamEventTableViewDataSource.h"

@interface BSProfileTeamTableViewDataSource : BSBaseTeamEventTableViewDataSource

- (BOOL)addFollowedTeam:(BSTeamMO *)team;
- (BOOL)removeFollowedTeam:(BSTeamMO *)team;

- (BOOL)addJoinedTeam:(BSTeamMO *)team;
- (BOOL)removeJoinedTeam:(BSTeamMO *)team;

@end
