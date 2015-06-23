//
//  BSAddSportsViewController.h
//  Bristol
//
//  Created by Bo on 2/28/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSAddSportsViewController : BSBaseTableViewController

@property (nonatomic, assign) BOOL autoSyncWithServer;// defaults to YES. sync with server after view is dealloc

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user;
+ (instancetype)instanceFromStoryboardWithTeam:(BSTeamMO *)team;

@end
