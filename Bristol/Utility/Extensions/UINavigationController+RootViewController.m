//
//  UINavigationController+RootViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UINavigationController+RootViewController.h"

@implementation UINavigationController (RootViewController)

- (UIViewController *)rootViewController {
    return self.viewControllers.count > 0 ? self.viewControllers[0] : nil;
}

@end
