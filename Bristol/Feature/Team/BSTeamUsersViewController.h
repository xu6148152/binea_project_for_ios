//
//  BSTeamUsersViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 3/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUsersViewController.h"
#import "BSTeamUserTableViewCell.h"

@interface BSTeamUsersViewController : BSBaseTableViewController<BSTeamUserTableViewCellDelegate>
- (void) configurePendingUsers:(NSMutableArray *)users ofTeam:(BSTeamMO *)team;
- (void) configureMembersWithTeam:(BSTeamMO *)team;
@end
