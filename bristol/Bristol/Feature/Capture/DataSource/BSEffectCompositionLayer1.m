//
//  BSEffectCompositionLayer1.m
//  AVFoundationEditor
//
//  Created by Guichao Huang (Gary) on 4/12/15.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import "BSEffectCompositionLayer1.h"
#import "CALayer+Geometry.h"

@implementation BSEffectCompositionLayer1
{
	CATextLayer *_locationNameLayer;
	CATextLayer *_teamNameLayer;
	CALayer *_teamLogoLayer;
	CALayer *_highlightFrameLayer;
	UIImage *_imageHighlightFrame;
}

#define kTextHeight (40)

- (id)init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (NSArray *)timesPivotToHighlightFrameTime:(NSTimeInterval)highlightFrameTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	return @[@(highlightFrameTime)];
}

#pragma mark - property
- (void)setTeam:(NSString *)team {
	[super setTeam:team];
	_teamNameLayer.string = team;
}

- (void)setLocation:(NSString *)location {
	[super setLocation:location];
	_locationNameLayer.string = location;
}

- (void)setImageTeamLogo:(UIImage *)imageTeamLogo {
	[super setImageTeamLogo:imageTeamLogo];
	_teamLogoLayer.contents = (id)(imageTeamLogo.CGImage);
}

- (void)setImagesPivotToHighlightFrame:(NSArray *)imagesPivotToHighlightFrame {
	_imageHighlightFrame = [imagesPivotToHighlightFrame firstObject];
	_highlightFrameLayer.contents = (id)(_imageHighlightFrame.CGImage);
}

#pragma mark - layer
- (CALayer *)layer {
	CALayer *rootLayer = [CALayer layer];
	rootLayer.bounds = self.bounds;
	CGFloat boundWidth = self.bounds.size.width;

	_highlightFrameLayer = [self createLayerWithImage:_imageHighlightFrame];
	CALayer *lightLayer = [CALayer layer];
	CALayer *tvLayer = [CALayer layer];
	
	CALayer *teamLayer = [self _createTeamLayer];
//	teamLayer.backgroundColor = [UIColor orangeColor].CGColor;
	CALayer *locationLayer = [self _createLocationLayerWithTop:teamLayer.top - kTextHeight - 20];
//	locationLayer.backgroundColor = [UIColor greenColor].CGColor;
	
	[rootLayer addSublayer:_highlightFrameLayer];
	[rootLayer addSublayer:locationLayer];
	[rootLayer addSublayer:teamLayer];
	[rootLayer addSublayer:lightLayer];
	[rootLayer addSublayer:tvLayer];

	// Opening
	[_highlightFrameLayer addAnimation:[self createScaleAnimationFromScale:1 toScale:1.2 duration:timeWithFrame(86) beginTime:AVCoreAnimationBeginTimeAtZero] forKey:nil];
	[_highlightFrameLayer addAnimation:[self createOpacityAnimationFromValue:1 toValue:0 duration:timeWithFrame(1) beginTime:timeWithFrame(87)] forKey:nil];

	[self _setLightAnimationForLayer:lightLayer beginTime:timeWithFrame(75)];

	[locationLayer addAnimation:[self createPositionXAnimationFromValue:boundWidth * 1.5 toValue:boundWidth * 0.5 duration:timeWithFrame(10) beginTime:AVCoreAnimationBeginTimeAtZero] forKey:nil];
	[locationLayer addAnimation:[self createPositionXAnimationFromValue:boundWidth * 0.5 toValue:boundWidth * 0.5-20 duration:timeWithFrame(66) beginTime:timeWithFrame(11)] forKey:nil];
	[locationLayer addAnimation:[self createPositionXAnimationFromValue:boundWidth * 0.5-20 toValue:-boundWidth * 0.5 duration:timeWithFrame(10) beginTime:timeWithFrame(77)] forKey:nil];
	
	[teamLayer addAnimation:[self createPositionXAnimationFromValue:-boundWidth * 0.5 toValue:boundWidth * 0.5 duration:timeWithFrame(10) beginTime:AVCoreAnimationBeginTimeAtZero] forKey:nil];
	[teamLayer addAnimation:[self createPositionXAnimationFromValue:boundWidth * 0.5 toValue:boundWidth * 0.5+20 duration:timeWithFrame(66) beginTime:timeWithFrame(11)] forKey:nil];
	[teamLayer addAnimation:[self createPositionXAnimationFromValue:boundWidth * 0.5+20 toValue:boundWidth * 1.5 duration:timeWithFrame(10) beginTime:timeWithFrame(77)] forKey:nil];

	// Closing
	CFTimeInterval beginTime = timeWithFrame(409);
	[self setTVAnimationForLayer:tvLayer beginTime:beginTime frameCount:41];
	[tvLayer addAnimation:[self createOpacityAnimationFromValue:0 toValue:1 duration:timeWithFrame(10) beginTime:beginTime] forKey:nil];

	return rootLayer;
}

- (CALayer *)_createTeamLayer {
	CALayer *teamLayer = [CALayer layer];
	teamLayer.frame = CGRectMake(-self.bounds.size.width, self.bounds.size.height - kTextHeight * 1.5, self.bounds.size.width, kTextHeight);
	
	_teamNameLayer = [self createLayerWithText:self.team fontSize:24 height:kTextHeight];
	_teamNameLayer.position = CGPointMake(CGRectGetMidX(teamLayer.bounds), CGRectGetMidY(teamLayer.bounds));
//	_teamNameLayer.backgroundColor = [UIColor redColor].CGColor;
	[teamLayer addSublayer:_teamNameLayer];
	
	_teamLogoLayer = [self createLayerWithImage:self.imageTeamLogo];
	_teamLogoLayer.bounds = CGRectMake(0, 0, kTextHeight, kTextHeight);
	_teamLogoLayer.position = CGPointMake(_teamNameLayer.left - kTextHeight + 5, _teamNameLayer.position.y - 5);
	[teamLayer addSublayer:_teamLogoLayer];
	
	return teamLayer;
}

- (CALayer *)_createLocationLayerWithTop:(CGFloat)top {
	CALayer *locationLayer = [CALayer layer];
	locationLayer.frame = CGRectMake(self.bounds.size.width, top, self.bounds.size.width, kTextHeight);
	
	_locationNameLayer = [self createLayerWithText:self.location fontSize:30 height:kTextHeight];
	_locationNameLayer.position = CGPointMake(CGRectGetMidX(locationLayer.bounds), CGRectGetMidY(locationLayer.bounds));
//	_locationNameLayer.backgroundColor = [UIColor blueColor].CGColor;
	[locationLayer addSublayer:_locationNameLayer];
	
	return locationLayer;
}

- (void)_setLightAnimationForLayer:(CALayer *)layer beginTime:(CFTimeInterval)beginTime {
	layer.frame = self.bounds;

	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	animation.calculationMode = kCAAnimationDiscrete;
	animation.beginTime = beginTime;

	NSMutableArray *images = [NSMutableArray array];
	for (uint i = 10; i <= 30; i++) {
		NSString *name = [NSString stringWithFormat:@"effect1_light_%i.png", i];
		UIImage *image = [UIImage imageNamed:name];
		[images addObject:(id)image.CGImage];
	}
	animation.values = images;
	animation.duration = timeWithFrame(images.count);
	animation.removedOnCompletion = NO;

	[layer addAnimation:animation forKey:@"contents"];
}

@end
