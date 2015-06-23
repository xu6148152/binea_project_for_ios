//
//  ZPVideoMerger.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/3/14.
//
//

#import "ZPVideoMerger.h"
#import "ZPVideoShared.h"

#import <AVFoundation/AVFoundation.h>

// Set Logging Component
#undef ZPLogComponent
#define ZPLogComponent lcl_cVideo

@implementation ZPVideoMerger

static NSString *const ErrorDomain = @"com.zepp";

+ (BOOL)_checkArray:(NSArray *)array isKindOfClass:(Class)class {
	for (NSObject *obj in array) {
		if (![obj isKindOfClass:class]) {
			return NO;
		}
	}
	return YES;
}

+ (BOOL)_isTransformPortrait:(CGAffineTransform)currentTransform {
	BOOL isPortrait = NO;
	if (currentTransform.a == 0 && currentTransform.b == 1.0 && currentTransform.c == -1.0 && currentTransform.d == 0) {
		isPortrait = YES;
	}
	if (currentTransform.a == 0 && currentTransform.b == -1.0 && currentTransform.c == 1.0 && currentTransform.d == 0) {
		isPortrait = YES;
	}
	if (currentTransform.a == 1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == 1.0) {
	}
	if (currentTransform.a == -1.0 && currentTransform.b == 0 && currentTransform.c == 0 && currentTransform.d == -1.0) {
	}

	return isPortrait;
}

+ (void)_mergeVideoWithUrls:(NSArray *)aryUrls outputURL:(NSURL *)outputURL presetName:(NSString *)presetName startTime:(CMTime)startTime endTime:(CMTime)endTime progressCallback:(ZPVideoMergerProgressCallback)progressCallback completionCallback:(ZPVideoMergerCompletionCallback)completionCallback {
	if (aryUrls.count == 0) {
		ZPLogDebug(@"aryUrls is empty");
		return;
	}

	if (![self _checkArray:aryUrls isKindOfClass:[NSURL class]]) {
		ZPLogDebug(@"aryUrls must be NSURL type");
		return;
	}
	if (!outputURL) {
		ZPInvokeBlock(completionCallback, [NSError errorWithDomain:ErrorDomain code:AVAssetExportSessionStatusFailed userInfo:nil]);
		return;
	}

	dispatch_queue_t _mergeQueue = dispatch_queue_create("com.zepp.videoMerger", DISPATCH_QUEUE_SERIAL);
	dispatch_async(_mergeQueue, ^{
	    CFAbsoluteTime startProcessingTime = CFAbsoluteTimeGetCurrent();

	    float minFrameRate = MAXFLOAT;
	    CGSize maxNaturalSize = CGSizeZero;
	    for (int i = 0; i < aryUrls.count; i++) {
	        AVAsset *currentAsset = [AVAsset assetWithURL:aryUrls[i]];
	        NSArray *videoTracks = [currentAsset tracksWithMediaType:AVMediaTypeVideo];
	        if (videoTracks.count > 0) {
	            AVAssetTrack *currentVideoTrack = videoTracks[0];
	            CGSize naturalSize = currentVideoTrack.naturalSize;
	            CGAffineTransform currentTransform = currentVideoTrack.preferredTransform;
	            BOOL isCurrentAssetPortrait = [self _isTransformPortrait:currentTransform];
	            if (isCurrentAssetPortrait) {
	                naturalSize = CGSizeMake(naturalSize.height, naturalSize.width);
				}
	            maxNaturalSize = CGSizeMake(MAX(maxNaturalSize.width, naturalSize.width), MAX(maxNaturalSize.height, naturalSize.height));

	            minFrameRate = MIN(minFrameRate, currentVideoTrack.nominalFrameRate);
			}
		}

	    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

		NSMutableArray *aryInstructions = [[NSMutableArray alloc] init];
		AVMutableCompositionTrack *videoCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
		AVMutableCompositionTrack *audioCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

	    CMTime currentTimeToWriteAt = kCMTimeZero;
	    CMTime currentTimeHasWrited = kCMTimeZero;
	    CMTime accumulateTimePre = kCMTimeZero;
	    CMTimeRange timeRangeToSplit;
	    for (int i = 0; i < aryUrls.count; i++) {
	        AVAsset *currentAsset = [AVAsset assetWithURL:aryUrls[i]];
	        CMTime accumulateTimePost = CMTimeAdd(accumulateTimePre, currentAsset.duration);

	        BOOL needsBreak = NO;
	        if (CMTimeCompare(accumulateTimePost, startTime) < 0) {
	            accumulateTimePre = accumulateTimePost;
	            continue;
			}
	        else {
	            if (CMTimeCompare(accumulateTimePre, startTime) <= 0) {
	                currentTimeToWriteAt = kCMTimeZero;
	                if (CMTimeCompare(accumulateTimePost, endTime) <= 0) {
	                    timeRangeToSplit = CMTimeRangeMake(CMTimeSubtract(startTime, accumulateTimePre), CMTimeSubtract(accumulateTimePost, startTime));
					}
	                else {
	                    timeRangeToSplit = CMTimeRangeMake(CMTimeSubtract(startTime, accumulateTimePre), CMTimeSubtract(endTime, startTime));
	                    needsBreak = YES;
					}
				}
	            else {
	                currentTimeToWriteAt = currentTimeHasWrited;
	                if (CMTimeCompare(accumulateTimePost, endTime) <= 0) {
	                    timeRangeToSplit = CMTimeRangeMake(kCMTimeZero, currentAsset.duration);
					}
	                else {
	                    timeRangeToSplit = CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(endTime, accumulateTimePre));
	                    needsBreak = YES;
					}
				}
			}

	        //video
	        NSArray *videoTracks = [currentAsset tracksWithMediaType:AVMediaTypeVideo];
	        if (videoTracks.count > 0) {
	            [videoCompositionTrack insertTimeRange:timeRangeToSplit ofTrack:videoTracks[0] atTime:currentTimeToWriteAt error:nil];
	            CGAffineTransform preferredTransform = ((AVAssetTrack *)videoTracks[0]).preferredTransform;
	            videoCompositionTrack.preferredTransform = preferredTransform;
			}
	        else
				continue;

	        currentTimeHasWrited = CMTimeAdd(currentTimeToWriteAt, timeRangeToSplit.duration);
	        accumulateTimePre = CMTimeAdd(accumulateTimePre, currentAsset.duration);

	        //audio
	        NSArray *audioTracks = [currentAsset tracksWithMediaType:AVMediaTypeAudio];
	        if (audioTracks.count > 0) {
	            [audioCompositionTrack insertTimeRange:timeRangeToSplit ofTrack:audioTracks[0] atTime:currentTimeToWriteAt error:nil];
			}

	        //orientation
	        AVMutableVideoCompositionLayerInstruction *compositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
	        AVAssetTrack *currentVideoTrack = videoTracks[0];

	        CGSize size = currentVideoTrack.naturalSize;
	        CGAffineTransform targetTransform = CGAffineTransformIdentity;
	        CGAffineTransform preferredTransform = currentVideoTrack.preferredTransform;
	        BOOL isCurrentAssetPortrait = [self _isTransformPortrait:preferredTransform];
	        if (isCurrentAssetPortrait) {
	            size = CGSizeMake(size.height, size.width);
			}
	        targetTransform = CGAffineTransformConcat(CGAffineTransformMakeTranslation((maxNaturalSize.width - size.width) / 2, (maxNaturalSize.height - size.height) / 2), targetTransform);
	        targetTransform = CGAffineTransformConcat(preferredTransform, targetTransform);
	        [compositionLayerInstruction setTransform:targetTransform atTime:currentTimeToWriteAt];

	        [compositionLayerInstruction setOpacity:0.0 atTime:currentTimeHasWrited];
	        [aryInstructions addObject:compositionLayerInstruction];
	        ZPLogDebug(@"video %i duration: %f", i, CMTimeGetSeconds(currentTimeHasWrited));

	        if (needsBreak)
				break;
		}

	    if (CMTimeCompare(currentTimeHasWrited, kCMTimeZero) == 0) {
	        ZPLogDebug(@"currentTimeHasWrited is not valid, will return");
	        ZPInvokeBlock(completionCallback, [NSError errorWithDomain:ErrorDomain code:AVAssetExportSessionStatusFailed userInfo:nil]);
	        return;
		}

	    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
	    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, currentTimeHasWrited);
	    mainInstruction.layerInstructions = aryInstructions;

	    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
	    videoComposition.instructions = [NSArray arrayWithObject:mainInstruction];
	    videoComposition.frameDuration = CMTimeMake(1, minFrameRate);
	    videoComposition.renderSize = maxNaturalSize;

	    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:presetName];
	    exporter.outputURL = outputURL;
	    exporter.outputFileType = AVFileTypeMPEG4;
	    exporter.videoComposition = videoComposition;
	    exporter.shouldOptimizeForNetworkUse = YES;
	    [exporter exportAsynchronouslyWithCompletionHandler: ^
	    {
	        CFAbsoluteTime endProcessingTime = CFAbsoluteTimeGetCurrent();
	        ZPLogDebug(@"total video merging time: %.3f s", (endProcessingTime - startProcessingTime));
	        dispatch_main_async_safe ( ^{
	            ZPInvokeBlock(completionCallback, exporter.error);
			});
		}];
	    ZPLogDebug(@"exportAsynchronouslyWithCompletionHandler is called");
	    if (progressCallback) {
	        // TODO: progress callback
		}
	});
}

+ (void)mergeVideoWithUrls:(NSArray *)aryUrls outputURL:(NSURL *)outputURL presetName:(NSString *)presetName progressCallback:(ZPVideoMergerProgressCallback)progressCallback completionCallback:(ZPVideoMergerCompletionCallback)completionCallback {
	[self _mergeVideoWithUrls:aryUrls outputURL:outputURL presetName:presetName startTime:kCMTimeZero endTime:kCMTimePositiveInfinity progressCallback:progressCallback completionCallback:completionCallback];
}

+ (void)mergeVideoWithUrls:(NSArray *)aryUrls outputURL:(NSURL *)outputURL presetName:(NSString *)presetName constrainDuration:(float)constrainDuration shiftDuration:(float)shiftDuration isForward:(BOOL)isForward progressCallback:(ZPVideoMergerProgressCallback)progressCallback completionCallback:(ZPVideoMergerCompletionCallback)completionCallback {
	float durationTotal = 0;
	AVAsset *asset;
	for (NSObject *obj in aryUrls) {
		if (![obj isKindOfClass:[NSURL class]]) {
			return;
		}

		asset = [AVAsset assetWithURL:(NSURL *)obj];
		durationTotal += (float)asset.duration.value / asset.duration.timescale;
	}

	if (constrainDuration <= 0 || constrainDuration > durationTotal) {
		constrainDuration = durationTotal;
	}

	shiftDuration = fabsf(shiftDuration);
	if ((constrainDuration + shiftDuration) > durationTotal) {
		shiftDuration = durationTotal - constrainDuration;
	}
	ZPLogDebug(@"shiftDuration for merge: %f", shiftDuration);

	CMTime startTime, endTime;
	if (isForward) {
		startTime = CMTimeMakeWithSeconds(shiftDuration, asset.duration.timescale);
		endTime = CMTimeMakeWithSeconds(constrainDuration, asset.duration.timescale);
	}
	else {
		startTime = CMTimeMakeWithSeconds(durationTotal - shiftDuration - constrainDuration, asset.duration.timescale);
		endTime = CMTimeMakeWithSeconds(durationTotal - shiftDuration, asset.duration.timescale);
	}

	[self _mergeVideoWithUrls:aryUrls outputURL:outputURL presetName:presetName startTime:startTime endTime:endTime progressCallback:progressCallback completionCallback:completionCallback];
}

@end
