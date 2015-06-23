//
//  UIView+Animation.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)shakeAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount completion:(ZPVoidBlock)completion {
	CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
	[shake setDuration:duration];
	[shake setRepeatCount:repeatCount];
	[shake setAutoreverses:YES];
	[shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.center.x - distance, self.center.y)]];
	[shake setToValue:[NSValue valueWithCGPoint:CGPointMake(self.center.x + distance, self.center.y)]];
	[CATransaction setCompletionBlock: ^{
	    ZPInvokeBlock(completion);
	}];

	[self.layer addAnimation:shake forKey:@"position"];
}

- (void)shakeAnimation {
	[self shakeAnimationWithDistance:10 duration:.1 repeatCount:2 completion:NULL];
}

@end
