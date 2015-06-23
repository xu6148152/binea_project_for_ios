//
//  BSEffectCompositionLayer2.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEffectCompositionLayer2.h"

@interface BSEffectCompositionLayer2()
{
	CALayer *_freezeFrameLayer1;
	CALayer *_freezeFrameLayer2;
	CALayer *_freezeFrameLayer3;
	CALayer *_freezeFrameLayer4;
	CIImage *_highlightFrame;
}

@end

@implementation BSEffectCompositionLayer2

- (id)init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (NSArray *)timesPivotToHighlightFrameTime:(NSTimeInterval)highlightFrameTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	NSTimeInterval actualTime = highlightFrameTime;
	if (actualTime - 1 < 0) {
		actualTime = 1;
	} else if (actualTime + 0.5 > inputVideoDuration) {
		actualTime = inputVideoDuration - 0.5;
	}
	
	return @[@(actualTime - 1), @(actualTime - 0.5), @(actualTime + 0), @(actualTime + 0.5)];
}

- (CIImage *)highlightFrame {
	UIImage *image = [self _getFreezeFrameImageAtIndex:2];
	_highlightFrame = [CIImage imageWithCGImage:image.CGImage];
	return _highlightFrame;
}

- (UIImage *)_getFreezeFrameImageAtIndex:(NSUInteger)index {
	if (index < self.imagesPivotToHighlightFrame.count) {
		return self.imagesPivotToHighlightFrame[index];
	} else {
		return nil;
	}
}

#pragma mark - layer
- (CALayer *)layer {
	CALayer *rootLayer = [CALayer layer];
	rootLayer.bounds = self.bounds;
	
	_freezeFrameLayer1 = [self createLayerWithImage:[self _getFreezeFrameImageAtIndex:0]];
	_freezeFrameLayer2 = [self createLayerWithImage:[self _getFreezeFrameImageAtIndex:1]];
	_freezeFrameLayer3 = [self createLayerWithImage:[self _getFreezeFrameImageAtIndex:2]];
	_freezeFrameLayer4 = [self createLayerWithImage:[self _getFreezeFrameImageAtIndex:3]];	
	_freezeFrameLayer2.opacity = _freezeFrameLayer3.opacity = _freezeFrameLayer4.opacity = 0;
	
	CALayer *tvLayer = [CALayer layer];
	
	[rootLayer addSublayer:_freezeFrameLayer1];
	[rootLayer addSublayer:_freezeFrameLayer2];
	[rootLayer addSublayer:_freezeFrameLayer3];
	[rootLayer addSublayer:_freezeFrameLayer4];
	[rootLayer addSublayer:tvLayer];
	
	// step 1
	[_freezeFrameLayer1 addAnimation:[self createScaleAnimationFromScale:1 toScale:1.05 duration:timeWithFrame(23) beginTime:AVCoreAnimationBeginTimeAtZero] forKey:nil];
	[_freezeFrameLayer1 addAnimation:[self createScaleAnimationFromScale:1.05 toScale:3 duration:timeWithFrame(10) beginTime:timeWithFrame(24)] forKey:nil];
	[_freezeFrameLayer1 addAnimation:[self createOpacityAnimationFromValue:1 toValue:0  duration:timeWithFrame(10) beginTime:timeWithFrame(24)] forKey:nil];
	
	[_freezeFrameLayer2 addAnimation:[self createScaleAnimationFromScale:0.5 toScale:1 duration:timeWithFrame(7) beginTime:timeWithFrame(18)] forKey:nil];
	[_freezeFrameLayer2 addAnimation:[self createScaleAnimationFromScale:1 toScale:1.05 duration:timeWithFrame(23) beginTime:timeWithFrame(26)] forKey:nil];
	[_freezeFrameLayer2 addAnimation:[self createScaleAnimationFromScale:1.05 toScale:3 duration:timeWithFrame(10) beginTime:timeWithFrame(50)] forKey:nil];
	[_freezeFrameLayer2 addAnimation:[self createOpacityAnimationFromValue:0 toValue:1  duration:timeWithFrame(7) beginTime:timeWithFrame(18)] forKey:nil];
	[_freezeFrameLayer2 addAnimation:[self createOpacityAnimationFromValue:1 toValue:0  duration:timeWithFrame(10) beginTime:timeWithFrame(50)] forKey:nil];
	
	[_freezeFrameLayer3 addAnimation:[self createScaleAnimationFromScale:0.5 toScale:1 duration:timeWithFrame(7) beginTime:timeWithFrame(43)] forKey:nil];
	[_freezeFrameLayer3 addAnimation:[self createScaleAnimationFromScale:1 toScale:1.05 duration:timeWithFrame(23) beginTime:timeWithFrame(51)] forKey:nil];
	[_freezeFrameLayer3 addAnimation:[self createScaleAnimationFromScale:1.05 toScale:3 duration:timeWithFrame(10) beginTime:timeWithFrame(75)] forKey:nil];
	[_freezeFrameLayer3 addAnimation:[self createOpacityAnimationFromValue:0 toValue:1  duration:timeWithFrame(7) beginTime:timeWithFrame(43)] forKey:nil];
	[_freezeFrameLayer3 addAnimation:[self createOpacityAnimationFromValue:1 toValue:0  duration:timeWithFrame(10) beginTime:timeWithFrame(75)] forKey:nil];
	
	[_freezeFrameLayer4 addAnimation:[self createScaleAnimationFromScale:0.5 toScale:1 duration:timeWithFrame(7) beginTime:timeWithFrame(68)] forKey:nil];
	[_freezeFrameLayer4 addAnimation:[self createScaleAnimationFromScale:1 toScale:1.05 duration:timeWithFrame(23) beginTime:timeWithFrame(76)] forKey:nil];
	[_freezeFrameLayer4 addAnimation:[self createScaleAnimationFromScale:1.05 toScale:3 duration:timeWithFrame(10) beginTime:timeWithFrame(100)] forKey:nil];
	[_freezeFrameLayer4 addAnimation:[self createOpacityAnimationFromValue:0 toValue:1  duration:timeWithFrame(7) beginTime:timeWithFrame(68)] forKey:nil];
	[_freezeFrameLayer4 addAnimation:[self createOpacityAnimationFromValue:1 toValue:0  duration:timeWithFrame(10) beginTime:timeWithFrame(100)] forKey:nil];
	
	// step 3
	CFTimeInterval beginTime = timeWithFrame(9 * kRenderedVideoFrameRate + 8);
	NSUInteger frameCount = 67;
	[self setTVAnimationForLayer:tvLayer beginTime:beginTime frameCount:frameCount];
	tvLayer.position = CGPointMake(self.bounds.size.width * .75, self.bounds.size.height / 2);
	[tvLayer addAnimation:[self createOpacityAnimationFromValue:0 toValue:1 duration:timeWithFrame(10) beginTime:beginTime] forKey:nil];
	[tvLayer addAnimation:[self createOpacityAnimationFromValue:1 toValue:0 duration:timeWithFrame(10) beginTime:beginTime + timeWithFrame(frameCount - 10)] forKey:nil];
	
	return rootLayer;
}
@end
