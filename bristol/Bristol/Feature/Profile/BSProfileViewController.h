//
//  BSProfileViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"
#import "BSLikeOrInviteButton.h"

@interface BSProfileViewController : BSTabbarBaseViewController

@property (weak, nonatomic) IBOutlet BSLikeOrInviteButton *btnSettingOrFollow;

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user;
+ (instancetype)instanceFromStoryboardWithTeam:(BSTeamMO *)team;
+ (instancetype)instanceFromStoryboardWithEvent:(BSEventMO *)event;
+ (instancetype)instanceFromStoryboardWithModel:(id)model;

@end
