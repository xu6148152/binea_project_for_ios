//
//  BSTeamSettingsViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSTeamSettingsViewController : BSBaseViewController
@property (nonatomic) BSTeamMO *team;

+ (instancetype)instanceFromStoryboard;
@end
