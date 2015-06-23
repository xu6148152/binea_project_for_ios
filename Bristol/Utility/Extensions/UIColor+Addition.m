//
//  UIColor+Addition.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

+ (UIColor *)colorWithRed255:(CGFloat)red green255:(CGFloat)green blue255:(CGFloat)blue alphaFloat:(CGFloat)alpha {
	return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}

@end
