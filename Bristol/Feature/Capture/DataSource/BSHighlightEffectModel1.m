//
//  BSHighlightEffectModel1.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightEffectModel1.h"

#define kSlomoScale (.5)

@implementation BSHighlightEffectModel1
{
	THVideoItem *_videoItemSlomo;
}

- (void)_generateVideoItemSlomo {
	_videoItemSlomo = [self.videoItemDefault copy];
	_videoItemSlomo.startTimeInTimeline = kCMTimeInvalid;
	_videoItemSlomo.scale = kSlomoScale;
}

- (void)setVideoItemDefault:(THVideoItem *)videoItemDefault {
	[super setVideoItemDefault:videoItemDefault];
	
	videoItemDefault.startTimeInTimeline = cmTimeWithSeconds(timeWithFrame(86));
}

- (BSCoreImageFilter)filterType {
	return BSCoreImageFilterGray;
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
	
	CGFloat selectedDuration = selectedEndTime - selectedBeginTime;
	self.videoItemDefault.timeRange = CMTimeRangeMake(cmTimeWithSeconds(selectedBeginTime), cmTimeWithSeconds(selectedDuration));
	
	CGFloat totalVideoDuration = kRenderedVideoDuration - CMTimeGetSeconds(self.videoItemDefault.startTimeInTimeline);
	CGFloat slomoDuration = (totalVideoDuration - selectedDuration) * kSlomoScale;
	if (slomoDuration > inputVideoDuration) {
		slomoDuration = inputVideoDuration;
	}
	CGFloat slomoDurationOneHalf = slomoDuration / 2;
	
	CGFloat slomoBeginTime = selectedHighlightTime - slomoDurationOneHalf;
	if ((selectedHighlightTime + slomoDurationOneHalf) > inputVideoDuration) {
		slomoBeginTime = inputVideoDuration - slomoDuration;
	}
	if (slomoBeginTime < 0) {
		slomoBeginTime = 0;
	}
	
	_videoItemSlomo.timeRange = CMTimeRangeMake(cmTimeWithSeconds(slomoBeginTime), cmTimeWithSeconds(slomoDuration));
}

@end
