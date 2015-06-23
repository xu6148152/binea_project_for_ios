//
//  BSCoreImageManager.m
//  AVFoundationEditor
//
//  Created by Guichao Huang (Gary) on 4/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCoreImageManager.h"
#import "BSCIMultiplyBlendFrameFilter.h"
#import "BSUIGlobal.h"

#import <AVFoundation/AVFoundation.h>

@interface BSCoreImageManager ()
{
}

@property (nonatomic, strong, readonly) CIFilter *grayFilter;
@property (nonatomic, strong, readonly) CIFilter *blurFilter;
@property (nonatomic, strong, readonly) BSCIMultiplyBlendFrameFilter *multiplyBlendFrameFilter;

@end

@implementation BSCoreImageManager

static BSCoreImageManager *_instance;
+ (instancetype)sharedManager {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [BSCoreImageManager new];
	});
	return _instance;
}

- (id)init {
	self = [super init];
	if (self) {
		_eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		_ciContext = [CIContext contextWithEAGLContext:_eaglContext options:@{ kCIContextWorkingColorSpace : [NSNull null] }];
		
		_grayFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:@"inputBrightness", @(0), @"inputContrast", @(1.1), @"inputSaturation", @(0), nil];
		_blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
		_multiplyBlendFrameFilter = [BSCIMultiplyBlendFrameFilter filter];
	}
	return self;
}

- (UIImage *)createUIImageFromCIImage:(CIImage *)ciimage {
	CGImageRef imageRef = [_ciContext createCGImage:ciimage fromRect:ciimage.extent];
	UIImage *image = [UIImage imageWithCGImage:imageRef];
	CFRelease(imageRef);
	
	return image;
}

- (UIImage *)_filterImage:(UIImage *)image withFilters:(NSArray *)filters {
	if (!image) {
		return nil;
	}
	
	CIImage *filteredImage = [CIImage imageWithCGImage:image.CGImage];
	for (CIFilter *filter in filters) {
		[filter setValue:filteredImage forKey:kCIInputImageKey];
		filteredImage = [filter valueForKey:kCIOutputImageKey];
	}
	
	return [self createUIImageFromCIImage:filteredImage];
}

- (UIImage *)filterImage:(UIImage *)image withFilter:(BSCoreImageFilter)filter {
	if (filter == BSCoreImageFilterNone) {
		return image;
	} else {
		NSMutableArray *filters = [NSMutableArray array];
		if ((filter & BSCoreImageFilterGray) == BSCoreImageFilterGray)
			[filters addObject:_grayFilter];
		if ((filter & BSCoreImageFilterBlur) == BSCoreImageFilterBlur)
			[filters addObject:_blurFilter];
		return [self _filterImage:image withFilters:filters];
	}
}

- (UIImage *)multiplyBlendImage:(UIImage *)image withColor:(UIColor *)color frameNormalized:(CGRect)frameNormalized {
	if (!image || !color) {
		return nil;
	}
	
	CIImage *filteredImage = [CIImage imageWithCGImage:image.CGImage];
	[_multiplyBlendFrameFilter setValue:filteredImage forKey:kCIInputImageKey];
	_multiplyBlendFrameFilter.frameNormalized = frameNormalized;
	filteredImage = [_multiplyBlendFrameFilter valueForKey:kCIOutputImageKey];
	
	return [self createUIImageFromCIImage:filteredImage];
}

- (UIImage *)multiplyBlendImage:(UIImage *)image {
	return [self multiplyBlendImage:image withColor:[BSUIGlobal multiplyBlendColor] frameNormalized:CGRectMake(0, 0, 1, 1)];
}

- (UIImage *)multiplyBlendImage:(UIImage *)image frameNormalized:(CGRect)frameNormalized {
	return [self multiplyBlendImage:image withColor:[BSUIGlobal multiplyBlendColor] frameNormalized:frameNormalized];
}

- (void)generateImageForVideoUrl:(NSURL *)url size:(CGSize)size withFilter:(BSCoreImageFilter)filter atTimes:(NSArray *)times completion:(void (^)(NSArray *images))completion {
	if (!url || !times) {
		ZPInvokeBlock(completion, nil);
        return;
	}
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		AVAsset *asset = [AVAsset assetWithURL:url];
		AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
		imageGenerator.appliesPreferredTrackTransform = YES;
		
		AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
		CGSize naturalSize = track.naturalSize;
		CGAffineTransform preferredTransform = track.preferredTransform;
		CGRect outRect = CGRectApplyAffineTransform(CGRectMake(0, 0, naturalSize.width, naturalSize.height), preferredTransform);
		outRect = rectScaleAspectFillSizeInSize(outRect.size, CGSizeMake(size.width + 1, size.height + 1)); //make generated image length is in kRenderedVideoSize
		imageGenerator.maximumSize = outRect.size;
		
		NSMutableArray *cmTimes = [NSMutableArray arrayWithCapacity:times.count];
		for (NSNumber *num in times) {
			CMTime cmTime = cmTimeWithSeconds([num floatValue]);
			[cmTimes addObject:[NSValue valueWithCMTime:cmTime]];
		}
		NSMutableArray *images = [NSMutableArray arrayWithCapacity:times.count];
		__block NSInteger countImplement = 0;
		[imageGenerator generateCGImagesAsynchronouslyForTimes:cmTimes completionHandler:^(CMTime requestedTime, CGImageRef cgImage, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
			UIImage *image = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationUp];
			if (image) {
				image = [self filterImage:image withFilter:filter];
				[images addObject:image];
			} else if (error) {
				ZPLogError(@"generate thumbnail at time:%f, error:%@", CMTimeGetSeconds(actualTime), error);
			}
			countImplement++;
			
			if (countImplement == times.count) {
				dispatch_main_async_safe(^ {
					ZPInvokeBlock(completion, images);
				});
			}
		}];
	});
}

@end
