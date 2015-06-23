//
//  BSLoadingImageView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLoadingImageView.h"

@implementation BSLoadingImageView

- (void)startLoadingAnimation {
	float angle = 2 * M_PI;
	CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
	rotationAnimation.duration = 1;
	rotationAnimation.repeatCount = HUGE_VALF;//infinite
	rotationAnimation.removedOnCompletion = NO;
	
	[self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopLoadingAnimation {
	[self.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
