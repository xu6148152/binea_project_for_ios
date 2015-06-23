//
//  BSVideoTrimmerView.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol BSVideoTrimmerViewDelegate;

@interface BSVideoTrimmerView : UIView

@property(nonatomic, assign, readonly) NSTimeInterval selectedHighlightTime;
@property(nonatomic, assign, readonly) NSTimeInterval inputVideoDuration;
@property(nonatomic, weak) id<BSVideoTrimmerViewDelegate> delegate;

+ (instancetype)videoTrimmerViewFromNib;

- (void)configNOEffectModeWithAsset:(AVAsset *)asset minVideoDuration:(NSTimeInterval)minVideoDuration maxVideoDuration:(NSTimeInterval)maxVideoDuration selectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime highlightTime:(NSTimeInterval)highlightTime;
- (void)setCursorTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)setMultiplyViewWork:(BOOL)isWork; // default is NO

- (void)setEffectModeWithSelectionDuration:(NSTimeInterval)duration;
- (void)setNOEffectMode;

- (void)generateThumbnailAtTime:(NSTimeInterval)time completion:(ZPImageBlock)completion;

- (CGPoint)highlightPointInWindowCoordinate;
- (CGPoint)heroFramePointInWindowCoordinate;

@end


@protocol BSVideoTrimmerViewDelegate <NSObject>
@optional
- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didBeginChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime;
- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime;
- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didEndChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime;

@end