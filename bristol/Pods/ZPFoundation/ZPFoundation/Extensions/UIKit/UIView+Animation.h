//
//  UIView+Animation.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPFoundation.h"

@interface UIView (Animation)

- (void)shakeAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount completion:(ZPVoidBlock)completion;
- (void)shakeAnimation;

@end
