//
//  BSCIMultiplyBlendCornerFilter.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIMultiplyBlendCornerFilter.h"

@implementation BSCIMultiplyBlendCornerFilter

+ (instancetype)filter {
	return (BSCIMultiplyBlendCornerFilter *)[CIFilter filterWithName:[BSCIMultiplyBlendCornerFilter className]];
}

- (id)init {
	self = [super init];
	if (self) {
		self.color = [CIColor colorWithRed:.73 green:.87 blue:.04 alpha:1];
		self.blendCorner = BSCIMultiplyBlendCornerBR;
	}
	return self;
}

- (CIColorKernel *)_kernel {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"MultiplyBlendCorner" ofType:@"cikernel"];
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

- (float)_cornerValueForCorner:(BSCIMultiplyBlendCorner)corner {
	float value = ((_blendCorner & corner) == corner) ? 1 : -1;
	return value;
}

- (CIImage *)outputImage {
	if (!self.inputImage) {
		return nil;
	}
	
	CGRect extent = self.inputImage.extent;
	float x = extent.size.width + extent.origin.x * 2;
	float y = extent.size.height + extent.origin.y * 2;
	CGRect corner = CGRectMake([self _cornerValueForCorner:BSCIMultiplyBlendCornerBL], [self _cornerValueForCorner:BSCIMultiplyBlendCornerBR], [self _cornerValueForCorner:BSCIMultiplyBlendCornerTR], [self _cornerValueForCorner:BSCIMultiplyBlendCornerTL]);
	return [[self _kernel] applyWithExtent:extent arguments:@[self.inputImage, self.color, [CIVector vectorWithX:x Y:y], [CIVector vectorWithCGRect:corner]]];
}

@end
