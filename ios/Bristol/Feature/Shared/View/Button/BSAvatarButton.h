//
//  BSAvatarButton.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseButton.h"

@class BSUserMO, BSTeamMO, BSEventMO;

@interface BSAvatarButton : BSBaseButton

@property (nonatomic, copy) ZPVoidBlock customTappedAction;

- (void)configWithUser:(BSUserMO *)user;
- (void)configWithTeam:(BSTeamMO *)team;
- (void)configWithEvent:(BSEventMO *)event;

@end
