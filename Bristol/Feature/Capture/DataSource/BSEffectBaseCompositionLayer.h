//
//  BSEffectBaseCompositionLayer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "THCompositionLayer.h"

#import <CoreText/CoreText.h>
#import <AVFoundation/AVFoundation.h>

@interface BSEffectBaseCompositionLayer : THCompositionLayer

@property (nonatomic, assign, readonly) CGRect bounds;

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *team;
@property (nonatomic, strong) UIImage *imageTeamLogo;
@property (nonatomic, strong) NSArray *imagesPivotToHighlightFrame;

- (NSArray *)timesPivotToHighlightFrameTime:(NSTimeInterval)highlightFrameTime inputVideoDuration:(NSTimeInterval)inputVideoDuration;

- (CALayer *)createLayerWithImage:(UIImage *)image;
- (CATextLayer *)createLayerWithText:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height;

- (CABasicAnimation *)createScaleAnimationFromScale:(CGFloat)fromScale toScale:(CGFloat)toScale duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime;
- (CABasicAnimation *)createPositionXAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime;
- (CABasicAnimation *)createOpacityAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CFTimeInterval)duration beginTime:(CFTimeInterval)beginTime;
- (void)setTVAnimationForLayer:(CALayer *)layer beginTime:(CFTimeInterval)beginTime frameCount:(NSUInteger)frameCount;

@end
