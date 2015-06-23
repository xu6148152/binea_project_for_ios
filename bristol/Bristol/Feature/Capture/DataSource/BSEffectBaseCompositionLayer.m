//
//  BSEffectBaseCompositionLayer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEffectBaseCompositionLayer.h"

@implementation BSEffectBaseCompositionLayer

- (id)init {
	self = [super init];
	if (self) {
		_bounds = CGRectMake(0, 0, kRenderedVideoSize.width, kRenderedVideoSize.height);
		self.startTimeInTimeline = cmTimeWithSeconds(0);
	}
	return self;
}

- (void)dealloc {
	
}

- (NSArray *)timesPivotToHighlightFrameTime:(NSTimeInterval)highlightFrameTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

#pragma mark - layer
- (CALayer *)createLayerWithImage:(UIImage *)image {
	if (!image) {
		return nil;
	}
	
	CALayer *layer = [CALayer layer];
	layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	layer.contents = (id)(image.CGImage);
	layer.contentsGravity = kCAGravityResizeAspect;
	
	return layer;
}

- (CATextLayer *)createLayerWithText:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height {
	CATextLayer *textLayer = [CATextLayer layer];
	textLayer.string = text;
	textLayer.fontSize = fontSize;
	textLayer.contentsGravity = kCAGravityBottom;
	textLayer.alignmentMode = @"center";
	
	NSString *fontName = @"Avenir-BlackOblique";
	textLayer.font = (__bridge CFTypeRef)fontName;
	
	textLayer.bounds = CGRectMake(0, 0, kRenderedVideoSize.width, height);
	textLayer.shadowOpacity = .75;
	textLayer.shadowOffset = CGSizeMake(0, 3);
	
	return textLayer;
}

#pragma mark - animation
- (CABasicAnimation *)createScaleAnimationFromScale:(CGFloat)fromScale toScale:(CGFloat)toScale duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	animation.fromValue = @(fromScale);
	animation.toValue = @(toScale);
	animation.duration = duration;
	animation.beginTime = beginTime;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	return animation;
}

- (CABasicAnimation *)createPositionXAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
	animation.fromValue = @(fromValue);
	animation.toValue = @(toValue);
	animation.duration = duration;
	animation.beginTime = beginTime;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	return animation;
}

- (CABasicAnimation *)createOpacityAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = @(fromValue);
	animation.toValue = @(toValue);
	animation.duration = duration;
	animation.beginTime = beginTime;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	return animation;
}

- (void)setTVAnimationForLayer:(CALayer *)layer beginTime:(CFTimeInterval)beginTime frameCount:(NSUInteger)frameCount {
	layer.frame = self.bounds;
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	animation.calculationMode = kCAAnimationDiscrete;
	animation.beginTime = beginTime;
	
	NSMutableArray *images = [NSMutableArray array];
	for (uint i = 1; i <= frameCount; i++) {
		NSUInteger i = [NSNumber randomUIntegerFrom:9 to:40];
		NSString *name = [NSString stringWithFormat:@"zepp_tv_logo00%02i.png", (int)i];
		UIImage *image = [UIImage imageNamed:name];
		NSAssert(image, @"tv frame not found");
		[images addObject:(id)image.CGImage];
	}
	animation.values = images;
	animation.duration = timeWithFrame(images.count);
	animation.removedOnCompletion = NO;
	
	[layer addAnimation:animation forKey:@"contents"];
}

@end
