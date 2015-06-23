//
//  UIImage+Resize.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)

// Proportionately resize, completely fit in view, no cropping
- (UIImage *)imageFitInSize:(CGSize)size;
// Center, no resize
- (UIImage *)imageCenterInSize:(CGSize)size;
// Fill all pixels
- (UIImage *)imageFillInSize:(CGSize)size;

@end


@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
