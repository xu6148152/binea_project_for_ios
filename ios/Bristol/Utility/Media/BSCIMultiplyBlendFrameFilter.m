//
//  BSCIMultiplyBlendFrameFilter.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIMultiplyBlendFrameFilter.h"

@implementation BSCIMultiplyBlendFrameFilter

- (id)init {
	self = [super init];
	if (self) {
		self.color = [CIColor colorWithRed:.73 green:.87 blue:.04 alpha:1];
		self.frameNormalized = CGRectZero;
	}
	return self;
}

- (void)setFrameNormalized:(CGRect)frameNormalized {
	// _frameNormalized, zero point is in Bottom Left
	if (!CGRectEqualToRect(_frameNormalized, frameNormalized)) {
		_frameNormalized = CGRectMake(frameNormalized.origin.x, 1 - frameNormalized.size.height - frameNormalized.origin.y, frameNormalized.size.width, frameNormalized.size.height);
	}
}

- (CIColorKernel *)_kernel {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"MultiplyBlendFrame" ofType:@"cikernel"];
	NSString *kernelStr = [NSString stringWithContentsOfFile:path
	                                                encoding:NSUTF8StringEncoding
	                                                   error:nil];
	static CIColorKernel *kernel = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		kernel = [CIColorKernel kernelWithString:kernelStr];
	});
	return kernel;
}

- (CIImage *)outputImage {
	CGRect dod = self.inputImage.extent;
	return [[self _kernel] applyWithExtent:dod arguments:@[self.inputImage, self.color, [CIVector vectorWithX:dod.size.width Y:dod.size.height], [CIVector vectorWithCGRect:self.frameNormalized]]];
}

@end
