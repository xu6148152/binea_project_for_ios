//
//  BSLikeOrInviteButton.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseButton.h"

@class BSUserMO, BSTeamMO, BSEventMO;

@interface BSLikeOrInviteButton : BSBaseButton

@property(nonatomic, assign) BOOL showBackgroundImage; // defaults to NO
@property(nonatomic, assign) BOOL enableAfterFollowed; // defaults to NO

- (void)configWithUser:(BSUserMO *)user;
- (void)configWithTeam:(BSTeamMO *)team;
- (void)configWithEvent:(BSEventMO *)event;

- (void)configWithInviteUser:(BSUserMO *)user ofTeam:(BSTeamMO *)team;

@end
