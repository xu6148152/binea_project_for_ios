//
//  BSEffectVideoCompositor1.m
//  AVFoundationEditor
//
//  Created by Guichao Huang (Gary) on 4/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEffectVideoCompositor1.h"
#import "BSCoreImageManager.h"
#import "BSCIMultiplyBlendCornerFilter.h"

#import <CoreImage/CoreImage.h>

// Ref: AVCustomEdit from Apple

@interface BSEffectVideoCompositor1 ()
{
	NSMutableDictionary *_filters;
}
@property(nonatomic, strong) CIFilter *grayFilter;
@property(nonatomic, strong) CIFilter *blurFilter;
@property(nonatomic, strong) CIFilter *pureColorFilter;
@property(nonatomic, strong) BSCIMultiplyBlendCornerFilter *multiplyBlendCornerFilter;
@property(nonatomic, assign) NSUInteger indexOfLastFilterFrame;

@end


@implementation BSEffectVideoCompositor1

- (id)init {
	self = [super init];
	if (self) {
		[self _setupFilters];
	}
	return self;
}

- (void)_setTransformFilterToCenterWithScale:(CGFloat)scale frameSize:(CGSize)frameSize {
	CGFloat padding = -(scale - 1) / 2;
	CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
	transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(frameSize.width * padding, frameSize.height * padding));
	[self.transformFilter setValue:[self transformToValue:transform] forKey:@"inputTransform"];
}

- (void)_setupFilters {
	_grayFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:@"inputBrightness", @(0), @"inputContrast", @(1.1), @"inputSaturation", @(0), nil];
	_pureColorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor", [CIColor colorWithRed:.78 green:.94 blue:.04 alpha:1], nil];
	_blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	_multiplyBlendCornerFilter = [BSCIMultiplyBlendCornerFilter filter];

	__weak typeof(self) weakSelf = self;
	BSFilterBlock pureColorFilterBlock = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		return @[weakSelf.pureColorFilter];
	};
	BSFilterBlock composeFilterBlock_Gray_Blur = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		int radius = (int)frameIndex - (int)weakSelf.indexOfLastFilterFrame;
		if (radius < 0)
			radius = 0;
		if (radius > 12)
			radius = 12;
//		ZPLogDebug(@"radius:%i", radius);
		[weakSelf.blurFilter setValue:@(radius) forKey:@"inputRadius"];
		return @[weakSelf.grayFilter, weakSelf.blurFilter];
	};
	BSFilterBlock composeFilterBlock_Gray_Transform = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		return @[weakSelf.transformFilter, weakSelf.grayFilter];
	};
	BSFilterBlock composeFilterBlock_Gray_Transform_Big = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.4 frameSize:frameSize];
		return @[weakSelf.transformFilter, weakSelf.grayFilter];
	};

	BSFilterBlock composeFilterBlock_TL = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerTL;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	BSFilterBlock composeFilterBlock_TR = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerTR;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	BSFilterBlock composeFilterBlock_BL = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerBL;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	BSFilterBlock composeFilterBlock_BR = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerBR;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	BSFilterBlock composeFilterBlock_TL_BR = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerTL | BSCIMultiplyBlendCornerBR;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	BSFilterBlock composeFilterBlock_BL_TR = ^NSArray * (CGSize frameSize, NSUInteger frameIndex) {
		[weakSelf _setTransformFilterToCenterWithScale:1.2 frameSize:frameSize];
		weakSelf.multiplyBlendCornerFilter.blendCorner = BSCIMultiplyBlendCornerBL | BSCIMultiplyBlendCornerTR;
		return @[weakSelf.transformFilter, weakSelf.grayFilter, weakSelf.multiplyBlendCornerFilter];
	};
	
	_filters = [NSMutableDictionary dictionary];
	_filters[@262] = composeFilterBlock_TR;
	_filters[@263] = composeFilterBlock_TR;
	_filters[@264] = composeFilterBlock_TR;
	_filters[@265] = composeFilterBlock_BL;
	_filters[@266] = composeFilterBlock_BL;
	_filters[@267] = composeFilterBlock_BL;
	_filters[@268] = composeFilterBlock_TL_BR;
	_filters[@269] = composeFilterBlock_TL_BR;
	_filters[@270] = composeFilterBlock_TL_BR;
	
	_filters[@271] = pureColorFilterBlock;
	_filters[@272] = pureColorFilterBlock;
	_filters[@273] = composeFilterBlock_BL_TR;
	_filters[@274] = composeFilterBlock_BL_TR;
	_filters[@275] = pureColorFilterBlock;
	_filters[@276] = pureColorFilterBlock;
	_filters[@277] = composeFilterBlock_BL_TR;
	_filters[@278] = composeFilterBlock_BL_TR;
	_filters[@279] = pureColorFilterBlock;
	_filters[@280] = pureColorFilterBlock;
	
	_filters[@281] = composeFilterBlock_Gray_Transform;
	_filters[@282] = composeFilterBlock_Gray_Transform;
	_filters[@283] = composeFilterBlock_Gray_Transform;
	_filters[@284] = composeFilterBlock_Gray_Transform;
	_filters[@285] = composeFilterBlock_Gray_Transform;
	_filters[@286] = composeFilterBlock_Gray_Transform;
	_filters[@287] = composeFilterBlock_TL;
	_filters[@288] = composeFilterBlock_TL;
	_filters[@289] = composeFilterBlock_TL;
	_filters[@290] = composeFilterBlock_Gray_Transform;
	_filters[@291] = composeFilterBlock_Gray_Transform;
	_filters[@292] = composeFilterBlock_TR;
	_filters[@293] = composeFilterBlock_TR;
	_filters[@294] = composeFilterBlock_TR;
	_filters[@295] = composeFilterBlock_Gray_Transform;
	_filters[@296] = composeFilterBlock_Gray_Transform;
	
	_filters[@297] = composeFilterBlock_BL;
	_filters[@298] = composeFilterBlock_BL;
	_filters[@299] = composeFilterBlock_BL;
	_filters[@300] = composeFilterBlock_Gray_Transform;
	_filters[@301] = composeFilterBlock_Gray_Transform;
	_filters[@302] = composeFilterBlock_BR;
	_filters[@303] = composeFilterBlock_BR;
	_filters[@304] = composeFilterBlock_BR;
	
	_filters[@368] = composeFilterBlock_Gray_Transform_Big;
	_filters[@369] = composeFilterBlock_Gray_Transform_Big;
	_filters[@378] = composeFilterBlock_Gray_Transform_Big;
	_filters[@379] = composeFilterBlock_Gray_Transform_Big;
	_filters[@403] = pureColorFilterBlock;
	_filters[@404] = pureColorFilterBlock;
	_filters[@407] = pureColorFilterBlock;
	_filters[@408] = pureColorFilterBlock;
	
	_indexOfLastFilterFrame = 409;
	_filters[@(_indexOfLastFilterFrame)] = composeFilterBlock_Gray_Blur;
}

- (CIImage *)processVideoFrameWithImages:(NSArray *)images frameSize:(CGSize)frameSize atIndex:(NSUInteger)index {
	if (images.count == 0) {
		return nil;
	}
	
	ZPLogDebug(@"frame index:%i, video count:%i", (int)index, (int)images.count);
	CIImage *filteredImage = [images firstObject];
	BSFilterBlock block;
	if (index > _indexOfLastFilterFrame) {
		block = _filters[@(_indexOfLastFilterFrame)];
	}
	else {
		block = _filters[@(index)];
	}
	NSArray *filters = block ? block(frameSize, index) : nil;
	if (filters) {
		for (CIFilter *filter in filters) {
			if (![filter.name isEqualToString:@"CIConstantColorGenerator"]) {
				[filter setValue:filteredImage forKey:kCIInputImageKey];
			}
			filteredImage = [filter valueForKey:kCIOutputImageKey];
		}
	}
	
	return filteredImage;
}

@end
