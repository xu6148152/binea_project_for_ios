//
//  BSTeamMemberTableViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTableViewDataSource.h"
#import "BSTeamMO.h"
#import "BSEventMO.h"

@interface BSTeamMemberTableViewDataSource : BSUserTableViewDataSource

+ (instancetype)dataSourceWithTeam:(BSTeamMO *)team;

@end


@interface BSEventFollowersTableViewDataSource : BSUserTableViewDataSource

+ (instancetype)dataSourceWithEvent:(BSEventMO *)event;

@end
