//
//  BSHighlightEffectModel0.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightEffectModel0.h"

@implementation BSHighlightEffectModel0

- (NSArray *)videoItems {
	return @[self.videoItemDefault];
}

- (void)setVideoItemDefault:(THVideoItem *)videoItemDefault {
	[super setVideoItemDefault:videoItemDefault];
	
	videoItemDefault.startTimeInTimeline = cmTimeWithSeconds(0);
}

- (NSTimeInterval)requiredVideoDuration {
	return 0;
}

- (void)updateVideoWithVideoItem:(THVideoItem *)videoItem {
	if (![self.videoItemDefault.url isEqual:videoItem.url]) {
		self.videoItemDefault = [videoItem copy];
	}
}

- (void)updateVideoWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion {
	if (![self.videoItemDefault.url isEqual:url]) {
		self.videoItemDefault = [THVideoItem videoItemWithURL:url];
		[self.videoItemDefault prepareWithCompletionBlock:^(BOOL complete) {
			ZPInvokeBlock(completion);
		}];
	}
}

- (void)didChangedSelectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime selectedHighlightTime:(NSTimeInterval)selectedHighlightTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	[super didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime selectedHighlightTime:selectedHighlightTime inputVideoDuration:inputVideoDuration];
	
	self.audioItemDefault.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoItemDefault.timeRange.duration);
	self.audioItemDefaultFadeOutAutomation.timeRange = CMTimeRangeMake(cmTimeWithSeconds(selectedEndTime - 1), self.audioItemDefaultFadeOutAutomation.timeRange.duration);
}

@end
