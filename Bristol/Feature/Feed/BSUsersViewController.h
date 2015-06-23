//
//  BSUsersViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"
#import "BSHighlightMO.h"

@interface BSUsersViewController : BSBaseTableViewController

+ (instancetype)instanceOfLikesWithHighlight:(BSHighlightMO *)highlight;
+ (instancetype)instanceOfFollowersWithUser:(BSUserMO *)user;
+ (instancetype)instanceOfFollowingWithUser:(BSUserMO *)user;

@end
