//
//  ZPBaseSystemActivity.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ZPBaseSystemActivity : UIActivity

@property (nonatomic, strong, readonly) UIViewController *presentingController;

- (id)initWithPresentingViewController:(UIViewController *)viewController;
- (NSString *)serviceType;

@end
