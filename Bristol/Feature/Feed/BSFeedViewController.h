//
//  BSFeedViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSFeedViewController : BSTabbarBaseViewController

+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight notification:(BSNotificationMO *)notification;
+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight;

@end
