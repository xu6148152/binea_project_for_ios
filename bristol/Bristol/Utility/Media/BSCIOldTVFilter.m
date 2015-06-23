//
//  BSCIOldTVFilter.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIOldTVFilter.h"
#import "BSCIDistortFilter.h"

static const CGFloat RollPercentMin = 0;
static const CGFloat RollPercentMax = 1;

@implementation BSCIOldTVFilter
{
	CIFilter *_compositionFilter;
	CIFilter *_lightenBlendFilter;
	CIFilter *_alphaFilter;
	BSCIDistortFilter *_distortFilter;
}

- (id)init {
	self = [super init];
	if (self) {
		_lineScreenFilter = [CIFilter filterWithName:@"CILineScreen"];
		[_lineScreenFilter setValue:@(degrees2Radian(90)) forKey:@"inputAngle"];
		[_lineScreenFilter setValue:@4 forKey:@"inputWidth"];
		[_lineScreenFilter setValue:@.1 forKey:@"inputSharpness"];
		
		_alphaFilter = [CIFilter filterWithName:@"CIColorMatrix"];
		CGFloat rgba[4] = {.0, .0, .0, .4};
		[_alphaFilter setValue:[CIVector vectorWithValues:rgba count:4] forKey:@"inputAVector"];
		
		_lightenBlendFilter = [CIFilter filterWithName:@"CILightenBlendMode"];
		_compositionFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
		
		_distortFilter = [BSCIDistortFilter filter];
		_distortFilter.horizontalDistortPercent = 0.06;
	}
	return self;
}

- (void)setRollPercent:(CGFloat)rollPercent {
	if (rollPercent >= RollPercentMin && rollPercent <= RollPercentMax) {
		_rollPercent = rollPercent;
	}
}

- (CIImage *)outputImage {
	if (!self.inputImage) {
		return nil;
	}
	
	CGRect extent = self.inputImage.extent;
	CGFloat y = _rollPercent * extent.size.height;
	CIImage *imageOriginalTop = [self.inputImage imageByCroppingToRect:CGRectMake(extent.origin.x, y, extent.size.width, extent.size.height - y)];
	imageOriginalTop = [imageOriginalTop imageByApplyingTransform:CGAffineTransformMakeTranslation(0, -imageOriginalTop.extent.origin.y)];
	
	CIImage *imageOriginalBottom = [self.inputImage imageByCroppingToRect:CGRectMake(extent.origin.x, 0, extent.size.width, y)];
	CGFloat translationY = -imageOriginalBottom.extent.origin.y + extent.size.height - y;
	imageOriginalBottom = [imageOriginalBottom imageByApplyingTransform:CGAffineTransformMakeTranslation(0, translationY)];
	
	[_compositionFilter setValue:imageOriginalBottom forKey:kCIInputBackgroundImageKey];
	[_compositionFilter setValue:imageOriginalTop forKey:kCIInputImageKey];
	CIImage *imageRolled = _compositionFilter.outputImage;
	
	[_lineScreenFilter setValue:imageRolled forKey:kCIInputImageKey];
	CIImage *imageLined = _lineScreenFilter.outputImage;
	
	// white noise
	CIImage *randomImage = [CIFilter filterWithName:@"CIRandomGenerator"].outputImage;
	randomImage = [randomImage imageByCroppingToRect:imageLined.extent];
//	CGFloat fineAmount = 0.01;
	CIImage *whiteSpecksImage = [CIFilter filterWithName:@"CIColorMatrix" keysAndValues:kCIInputImageKey, randomImage,
								 @"inputRVector", [CIVector vectorWithX:1.0 Y:0.0 Z:0.0 W:0.0],
								 @"inputGVector", [CIVector vectorWithX:0.0 Y:1.0 Z:0.0 W:0.0],
								 @"inputBVector", [CIVector vectorWithX:0.0 Y:0.0 Z:1.0 W:0.0],
								 @"inputAVector", [CIVector vectorWithX:0.0 Y:0.0 Z:0.0 W:0.3],
								 @"inputBiasVector", [CIVector vectorWithX:0.0 Y:0.0 Z:0.0 W:0.0],
								 nil].outputImage;
	imageLined = [CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey, whiteSpecksImage, kCIInputBackgroundImageKey, imageLined, nil].outputImage;
	
	[_alphaFilter setValue:imageLined forKey:kCIInputImageKey];
	imageLined = _alphaFilter.outputImage;
	
	[_lightenBlendFilter setValue:imageRolled forKey:kCIInputImageKey];
	[_lightenBlendFilter setValue:imageLined forKey:kCIInputBackgroundImageKey];
	CIImage *imageBlend = _lightenBlendFilter.outputImage;
	
	[_distortFilter setValue:imageBlend forKey:kCIInputImageKey];
	imageBlend = _distortFilter.outputImage;
	
	return imageBlend;
}

@end
