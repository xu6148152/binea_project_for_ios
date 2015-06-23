//
//  BSHighlightBaseEffectModel.m
//  Bristol
//
//  Created by Gary Wong on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightBaseEffectModel.h"
#import "THVolumeAutomation.h"

@implementation BSHighlightBaseEffectModel
{
	Class _compositionLayerClass;
	BSEffectBaseCompositionLayer *_compositionLayer;
	NSTimeInterval _selectedEndTime;
}

+ (instancetype)highlightEffectModelWithName:(NSString *)name iconNormal:(NSString *)iconNormal iconHighlight:(NSString *)iconHighlight audioUrl:(NSURL *)audioUrl compositionLayerClass:(Class)compositionLayerClass videoCompositorClass:(Class)videoCompositorClass {
	return [[[self class] alloc] initWithName:name iconNormal:iconNormal iconHighlight:iconHighlight audioUrl:audioUrl compositionLayerClass:compositionLayerClass videoCompositorClass:videoCompositorClass];
}

- (id)initWithName:(NSString *)name iconNormal:(NSString *)iconNormal iconHighlight:(NSString *)iconHighlight audioUrl:(NSURL *)audioUrl compositionLayerClass:(Class)compositionLayerClass videoCompositorClass:(Class)videoCompositorClass {
    self = [super init];
    if (self) {
        _name = name;
        _iconNormal = iconNormal;
        _iconHighlight = iconHighlight;
		[self updateAudioWithUrl:audioUrl completion:nil];
		_compositionLayerClass = compositionLayerClass;
		_videoCompositorClass = videoCompositorClass;
    }
    
    return self;
}

- (void)dealloc {
	
}

- (BSEffectBaseCompositionLayer *)compositionLayer {
	if (!_compositionLayer && _compositionLayerClass) {
		_compositionLayer = [_compositionLayerClass new];
	}
	return _compositionLayer;
}

- (NSArray *)musicItems {
	if (!_audioItemDefault) {
		return nil;
	}
	
	return @[_audioItemDefault];
}

- (NSArray *)titleItems {
	BSEffectBaseCompositionLayer *layer = [self compositionLayer];
	if (layer) {
		return @[layer];
	} else {
		return nil;
	}
}

- (void)updateAudioWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion {
	_audioUrl = url;
	if (!url) {
		_audioItemDefault = nil;
		
		ZPInvokeBlock(completion);
	} else {
		_audioItemDefault = [THAudioItem audioItemWithURL:url];
		_audioItemDefault.startTimeInTimeline = cmTimeWithSeconds(0);
		
		CMTime fadeDuration = cmTimeWithSeconds(1);
		THVolumeAutomation *fadeInAutomation = [THVolumeAutomation volumeAutomationWithTimeRange:CMTimeRangeMake(kCMTimeZero, fadeDuration) startVolume:0 endVolume:1];
		_audioItemDefaultFadeOutAutomation = [THVolumeAutomation volumeAutomationWithTimeRange:CMTimeRangeMake(cmTimeWithSeconds(_selectedEndTime - 1), fadeDuration) startVolume:1 endVolume:0];
		_audioItemDefault.volumeAutomation = @[fadeInAutomation, _audioItemDefaultFadeOutAutomation];
		
		[_audioItemDefault prepareWithCompletionBlock:^(BOOL complete) {
			ZPInvokeBlock(completion);
		}];
	}
}

- (NSTimeInterval)requiredVideoDuration {
	NSAssert(NO, OverwriteRequiredMessage);
	return 0;
}

- (void)updateVideoWithVideoItem:(THVideoItem *)videoItem {
	NSAssert(NO, OverwriteRequiredMessage);
}

- (void)updateVideoWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion {
	NSAssert(NO, OverwriteRequiredMessage);
}

- (void)didChangedSelectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime selectedHighlightTime:(NSTimeInterval)selectedHighlightTime inputVideoDuration:(NSTimeInterval)inputVideoDuration {
	_selectedEndTime = selectedEndTime;
	self.videoItemDefault.timeRange = CMTimeRangeMake(cmTimeWithSeconds(selectedBeginTime), cmTimeWithSeconds(selectedEndTime - selectedBeginTime));
}

@end
