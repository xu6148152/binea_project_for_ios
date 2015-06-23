//
//  UINavigationBar+CustomHeight.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/27/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UINavigationBar+CustomHeight.h"
#import "objc/runtime.h"

static char const *const heightKey = "Height";

@implementation UINavigationBar (CustomHeight)

- (void)setHeight:(CGFloat)height
{
    objc_setAssociatedObject(self, heightKey, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)height
{
    return [objc_getAssociatedObject(self, heightKey) floatValue];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize;
    
    if (self.height) {
        newSize = CGSizeMake(self.superview.bounds.size.width, self.height);
    } else {
        newSize = [super sizeThatFits:size];
    }
    
    return newSize;
}

@end