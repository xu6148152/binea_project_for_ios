//
//  BSTeamInvitationViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSTeamInvitationViewController : BSBaseViewController<UITextFieldDelegate>
@property (nonatomic) BSTeamMO *team;
+ (instancetype)instanceFromStoryboard;

@end
