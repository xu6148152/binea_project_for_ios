//
//  BSBaseVideoCompositor.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseVideoCompositor.h"
#import "BSCoreImageManager.h"

#import "AVMutableVideoCompositionLayerInstruction+THAdditions.h"

@interface BSBaseVideoCompositor()
{
	BOOL _shouldCancelAllRequests;
	dispatch_queue_t _renderingQueue;
	dispatch_queue_t _renderContextQueue;
}
@end


@implementation BSBaseVideoCompositor

- (id)init {
	self = [super init];
	if (self) {
		_renderingQueue = dispatch_queue_create("com.zepp.zepptv.renderingqueue", DISPATCH_QUEUE_SERIAL);
		_renderContextQueue = dispatch_queue_create("com.zepp.zepptv.rendercontextqueue", DISPATCH_QUEUE_SERIAL);

		_transformFilter = [CIFilter filterWithName:@"CIAffineTransform"];
	}
	return self;
}

- (void)dealloc {
	
}

- (NSValue *)transformToValue:(CGAffineTransform)transform {
	return [NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)];
}

- (CIImage *)processVideoFrameWithImages:(NSArray *)images frameSize:(CGSize)frameSize atIndex:(NSUInteger)index {
	NSAssert(NO, OverwriteRequiredMessage);
	return [images firstObject];
}

#pragma mark - AVVideoCompositing
- (NSDictionary *)sourcePixelBufferAttributes {
	return @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange],
			  (NSString *)kCVPixelBufferOpenGLESCompatibilityKey : [NSNumber numberWithBool:YES] };
}

- (NSDictionary *)requiredPixelBufferAttributesForRenderContext {
	return @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange],
			  (NSString *)kCVPixelBufferOpenGLESCompatibilityKey : [NSNumber numberWithBool:YES] };
}

- (void)renderContextChanged:(AVVideoCompositionRenderContext *)newRenderContext {
	dispatch_sync(_renderContextQueue, ^() {
		_renderContext = newRenderContext;
	});
}

- (void)startVideoCompositionRequest:(AVAsynchronousVideoCompositionRequest *)request {
	@autoreleasepool {
		dispatch_async(_renderingQueue, ^() {
			// Check if all pending requests have been cancelled
			if (_shouldCancelAllRequests) {
				[request finishCancelledRequest];
			}
			else {
				CMTime compositionTime = request.compositionTime;
				if (compositionTime.timescale != kRenderedVideoFrameRate) {
					compositionTime.value *= (kRenderedVideoFrameRate / compositionTime.timescale);
					compositionTime.timescale = kRenderedVideoFrameRate;
				}
				NSUInteger indexOfCurrentFrame = (NSUInteger)compositionTime.value;
				
				AVMutableVideoCompositionInstruction *compositionInstruction = (AVMutableVideoCompositionInstruction *)request.videoCompositionInstruction;
				
				NSMutableArray *images = [NSMutableArray array];
				for (NSNumber *num in request.sourceTrackIDs) {
					CGAffineTransform transform = compositionInstruction.transform;
					
					CMPersistentTrackID trackID = [num intValue];
					CVPixelBufferRef sourceBuffer = [request sourceFrameByTrackID:trackID];
					int bufferHeight = (int)CVPixelBufferGetHeight(sourceBuffer);
					CGAffineTransform flip = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMake(1, 0, 0, -1, 0, bufferHeight), transform), CGAffineTransformMake(1, 0, 0, -1, 0, request.renderContext.size.height));
					[_transformFilter setValue:[self transformToValue:flip] forKey:@"inputTransform"];
					CIImage *filteredImage = [CIImage imageWithCVPixelBuffer:sourceBuffer];
					[_transformFilter setValue:filteredImage forKey:kCIInputImageKey];
					filteredImage = [_transformFilter valueForKey:kCIOutputImageKey];
					if (filteredImage) {
						[images addObject:filteredImage];
					}
				}
				
				CVPixelBufferRef filteredPixels = [self.renderContext newPixelBuffer];
				CIImage *filteredImage = [self processVideoFrameWithImages:images frameSize:request.renderContext.size atIndex:indexOfCurrentFrame];
				if (filteredImage) {
					[[BSCoreImageManager sharedManager].ciContext render:filteredImage toCVPixelBuffer:filteredPixels];
				}
				
				if (filteredPixels) {
					[request finishWithComposedVideoFrame:filteredPixels];
					CFRelease(filteredPixels);
				}
				else {
					[request finishWithError:nil];
				}
			}
		});
	}
}

- (void)cancelAllPendingVideoCompositionRequests {
	// pending requests will call finishCancelledRequest, those already rendering will call finishWithComposedVideoFrame
	_shouldCancelAllRequests = YES;
	
	dispatch_barrier_async(_renderingQueue, ^() {
		// start accepting requests again
		_shouldCancelAllRequests = NO;
	});
}

@end
