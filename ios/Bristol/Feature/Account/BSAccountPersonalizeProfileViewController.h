//
//  BSAccountPersonalizeProfileViewController.h
//  Bristol
//
//  Created by Bo on 3/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountBaseViewController.h"
#import "BSUserMO.h"

@interface BSAccountPersonalizeProfileViewController : BSAccountBaseViewController

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user;
+ (instancetype)instanceFromStoryboardWithEmail:(NSString *)email;

@end
