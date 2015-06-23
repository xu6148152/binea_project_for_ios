//
//  BSHighlightEffectModel2.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightEffectModel2.h"

#define kSlomoScale (.5)

@implementation BSHighlightEffectModel2
{
	THVideoItem *_videoItemSlomo;
}

- (BSEffectCompositionLayer2 *)compositionLayer2 {
	return (BSEffectCompositionLayer2 *)self.compositionLayer;
}

- (void)_generateVideoItemSlomo {
	_videoItemSlomo = [self.videoItemDefault copy];
	_videoItemSlomo.scale = kSlomoScale;
}

- (void)setVideoItemDefault:(THVideoItem *)videoItemDefault {
	[super setVideoItemDefault:videoItemDefault];
	
	videoItemDefault.startTimeInTimeline = cmTimeWithSeconds(timeWithFrame(75));
}

- (NSArray *)videoItems {
	return @[self.videoItemDefault, _videoItemSlomo];
}

- (NSTimeInterval)requiredVideoDuration {
	return 6;
}

- (void)updateVideoWithVideoItem:(THVideoItem *)videoItem {
	if (![self.videoItemDefault.url isEqual:videoItem.url]) {
		self.videoItemDefault = [videoItem copy];
		[self _generateVideoItemSlomo];
	}
}

- (void)updateVideoWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion {
	if (![self.videoItemDefault.url isEqual:url]) {
		self.videoItemDefault = [THVideoItem videoItemWithURL:url];
		[self.videoItemDefault prepareWithCompletionBlock:^(BOOL complete) {
			[self _generateVideoItemSlomo];
			
			ZPInvokeBlock(completion);
		}];
	}
}

- (void)didChangedSelectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime selectedHighlightTime:(NSTimeInterval)selectedHighlightTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	[super didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime selectedHighlightTime:selectedHighlightTime inputVideoDuration:inputVideoDuration];
	
	self.audioItemDefault.timeRange = CMTimeRangeMake(kCMTimeZero, cmTimeWithSeconds(kRenderedVideoDuration));
	self.audioItemDefaultFadeOutAutomation.timeRange = CMTimeRangeMake(cmTimeWithSeconds(kRenderedVideoDuration - 1), self.audioItemDefaultFadeOutAutomation.timeRange.duration);

	CGFloat duration = timeWithFrame(245);
	CGFloat startTime = selectedBeginTime;
	if ((startTime + duration) > inputVideoDuration) {
		startTime = inputVideoDuration - duration;
	}
	self.videoItemDefault.timeRange = CMTimeRangeMake(cmTimeWithSeconds(startTime), cmTimeWithSeconds(duration));// TODO:
	
	CGFloat startFrame = 263;
	CGFloat slomoDuration = timeWithFrame(kRenderedVideoDuration * kRenderedVideoFrameRate - startFrame) * kSlomoScale;
	if (slomoDuration > inputVideoDuration) {
		slomoDuration = inputVideoDuration;
	}
	startTime = selectedHighlightTime - timeWithFrame(55);
	if (startTime < 0)
		startTime = 0;
	if ((startTime + slomoDuration) > kRenderedVideoDuration) {
		startTime = kRenderedVideoDuration - slomoDuration;
	}
	_videoItemSlomo.timeRange = CMTimeRangeMake(cmTimeWithSeconds(startTime), cmTimeWithSeconds(slomoDuration));
	_videoItemSlomo.startTimeInTimeline = cmTimeWithSeconds(timeWithFrame(startFrame));
}

@end
