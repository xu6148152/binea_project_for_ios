//
//  ZPProgressView.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/9/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPMacros.h"

IB_DESIGNABLE
@interface ZPProgressView : UIView

@property (nonatomic, assign) IBInspectable CGFloat progress;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *backgroundTintColor;
@property (nonatomic, strong) IBInspectable UIColor *progressTintColor;

- (void)setProgress:(CGFloat)progress animationDuration:(CGFloat)duration completeBlock:(ZPVoidBlock)completeBlock;
- (void)cancelAnimation;

@end
