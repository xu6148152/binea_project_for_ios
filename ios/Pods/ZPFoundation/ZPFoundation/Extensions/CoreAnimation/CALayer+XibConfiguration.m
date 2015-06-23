//
//  CALayer+XibConfiguration.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "CALayer+XibConfiguration.h"
#import "ZPGeometry.h"
#import <objc/runtime.h>

@implementation CALayer (XibConfiguration)

- (void)setBorderUIColor:(UIColor *)color {
	self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
	return [UIColor colorWithCGColor:self.borderColor];
}

@end


@implementation UIView (XibConfiguration)

static char kRotateAngle;

- (void)setBackgroundUIColor:(UIColor *)backgroundUIColor {
    self.backgroundColor = backgroundUIColor;
}

- (UIColor *)backgroundUIColor {
    return self.backgroundColor;
}

- (void)setRotateAngle:(CGFloat)rotateAngle {
    [self willChangeValueForKey:@"rotateAngle"];
    
    objc_setAssociatedObject(self, &kRotateAngle, @(rotateAngle), OBJC_ASSOCIATION_ASSIGN);
    self.transform = CGAffineTransformRotate(self.transform, degrees2Radian(rotateAngle));
    
    [self didChangeValueForKey:@"rotateAngle"];
}

- (CGFloat)rotateAngle {
    return [objc_getAssociatedObject(self, &kRotateAngle) floatValue];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    self.layer.anchorPoint = anchorPoint;
    
    CGFloat tx = (anchorPoint.x - 0.5) * self.bounds.size.width;
    CGFloat ty = (0.5 - anchorPoint.y) * self.bounds.size.height;
    self.transform = CGAffineTransformTranslate(self.transform, tx, ty);
}

- (CGPoint)anchorPoint {
    return self.layer.anchorPoint;
}

@end
