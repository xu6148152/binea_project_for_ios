//
//  BSCIDistortFilter.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIDistortFilter.h"
#import "NSNumber+Random.h"

@interface BSCIDistortFilter()
{
	CGFloat _paddingMax;
}
@property(nonatomic, strong) CIImage *imageLookup;

@end

@implementation BSCIDistortFilter

- (id)init {
	self = [super init];
	if (self) {
		self.randomDistortInEachFrame = YES;
	}
	return self;
}

- (CIImage *)imageLookup {
	if (!_imageLookup) {
		[self _generateRandomLookupImage];
	}
	return _imageLookup;
}

- (void)_generateRandomLookupImage {
	const unsigned int width = 1;
	const unsigned int height = self.inputImage.extent.size.height;
	_paddingMax = self.inputImage.extent.size.width *_horizontalDistortPercent;
	NSLog(@"_paddingMax:%.1f", _paddingMax);
	CGFloat lastPadding = 0;
	CGFloat sign = 1;
	unsigned char *rawData = malloc(width*height*4);
	for (int i=0; i<width*height; ++i)
	{
		CGFloat random;
		if (i % 20 == 0) {
			random = [NSNumber randomFloatFrom:-1 to:1] * 5;
			sign = [NSNumber randomBOOL] ? 1 : -1;
		} else {
			random = [NSNumber randomFloatFrom:0 to:1] * 1 * sign;
		}
		lastPadding += random;
		if (lastPadding > _paddingMax) {
			lastPadding = _paddingMax;
		} else if (lastPadding < -_paddingMax) {
			lastPadding = -_paddingMax;
		}
		unsigned char r = lastPadding + _paddingMax;
//		NSLog(@"r:%i", r);
		rawData[4*i] = r;
		rawData[4*i+1] = 0;
		rawData[4*i+2] = 0;
		rawData[4*i+3] = 255;
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, width*height*4, NULL);
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, provider, NULL, NO, kCGRenderingIntentDefault);
	
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	_imageLookup = [CIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	free(rawData);
}

- (void)setHorizontalDistortPercent:(CGFloat)horizontalDistortPercent {
	if (_horizontalDistortPercent != horizontalDistortPercent) {
		if (horizontalDistortPercent < 0) {
			horizontalDistortPercent = 0;
		} else if (horizontalDistortPercent > 0.3) {
			horizontalDistortPercent = 0.3;
		}
		_horizontalDistortPercent = horizontalDistortPercent;
		
		_imageLookup = nil;
	}
}

- (CIKernel *)_kernel {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Distort" ofType:@"cikernel"];
	NSString *kernelStr = [NSString stringWithContentsOfFile:path
													encoding:NSUTF8StringEncoding
													   error:nil];
	static CIKernel *kernel = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		kernel = [CIKernel kernelWithString:kernelStr];
	});
	return kernel;
}

- (CIImage *)outputImage {
	if (_randomDistortInEachFrame) {
		_imageLookup = nil;
	}
	
	CGRect extent = self.inputImage.extent;
	CIImage *result = [[self _kernel] applyWithExtent:extent roiCallback:^CGRect(int index, CGRect rect) {
		return extent;
	} arguments:@[self.inputImage, [CIVector vectorWithX:extent.size.width Y:extent.size.height], self.imageLookup, @(_paddingMax/2)]];
	
	return result;
}

@end
