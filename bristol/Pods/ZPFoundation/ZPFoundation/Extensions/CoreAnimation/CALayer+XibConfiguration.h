//
//  CALayer+XibConfiguration.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (XibConfiguration)

@property (nonatomic, assign) UIColor *borderUIColor;

@end

@interface UIView (XibConfiguration)

@property (nonatomic, assign) UIColor *backgroundUIColor;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGPoint anchorPoint;

@end
