//
//  BSAccountLoginViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/28/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountBaseViewController.h"

@interface BSAccountLoginViewController : BSAccountBaseViewController

@property (nonatomic, assign) BOOL createProfileWithZeppUser;
@property (nonatomic, strong) NSString *zeppAccount;

@end
