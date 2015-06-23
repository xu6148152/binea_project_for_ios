//
//  BSEffectVideoCompositor2.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEffectVideoCompositor2.h"
#import "BSHighlightEffectManager.h"
#import "BSCIOldTVFilter.h"

typedef CIImage * (^BSEffect2FilterBlock)(NSArray *images, CGSize frameSize, NSUInteger frameIndex);

@interface BSEffectVideoCompositor2()
{
	NSMutableDictionary *_filters;
}
@property (nonatomic, strong) CIFilter *alphaFilter;
@property (nonatomic, strong) CIFilter *compositingFilter;
@property (nonatomic, strong) BSCIOldTVFilter *oldTVFilter;
@property (nonatomic, strong) CIImage *ciImageSecondHalf;
@property (nonatomic, assign) NSUInteger indexOfLastFilterFrame;
@property (nonatomic, assign) CGFloat alphaToDimPerFrame;

@end


@implementation BSEffectVideoCompositor2

- (id)init {
	self = [super init];
	if (self) {
		[self _setupFilters];
		_ciImageSecondHalf = [BSHighlightEffectManager sharedInstance].effectModel2.compositionLayer2.highlightFrame;
		CGRect rect = rectCenterSizeInSize(CGSizeMake(kRenderedVideoSize.width / 2, kRenderedVideoSize.height), _ciImageSecondHalf.extent.size);
		_ciImageSecondHalf = [_ciImageSecondHalf imageByCroppingToRect:rect];
	}
	return self;
}

- (void)_setupFilters {
	_alphaFilter = [CIFilter filterWithName:@"CIColorMatrix"];
	_compositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
	_oldTVFilter = [BSCIOldTVFilter filter];
	
	NSUInteger slideFrameBegin = 263;
	NSUInteger slideFrameEnd = 347;
	NSUInteger framesToExpand = 10;
	__weak typeof(self) weakSelf = self;
	BSEffect2FilterBlock alphaFilterBlock = ^CIImage * (NSArray *images, CGSize frameSize, NSUInteger frameIndex) {
		NSUInteger delta = frameIndex - weakSelf.indexOfLastFilterFrame;
		CGFloat alpha = 1 - weakSelf.alphaToDimPerFrame * delta;
//		ZPLogDebug(@"alpha:%.2f, frameIndex:%i", alpha, (int)frameIndex); // TODO:
		return [weakSelf _filterAlpha:alpha withImage:[images firstObject]];
	};
	BSEffect2FilterBlock splitFilterBlock = ^CIImage * (NSArray *images, CGSize frameSize, NSUInteger frameIndex) {
		if (images.count > 1) {
			CGFloat frameWidthOneHalf = frameSize.width / 2;
			CGFloat frameWidthOneFourth = frameSize.width / 4;
			CIImage *imageBG = [images firstObject];
			CIImage *imageSlomo = [images lastObject];
			CIImage *imageSlomoCrop = [imageSlomo imageByCroppingToRect:CGRectMake(frameWidthOneFourth, 0, frameWidthOneHalf, frameSize.height)];
			if (frameIndex < (slideFrameBegin + 15)) {
				// first half slide in
				CGFloat translationX = -imageSlomoCrop.extent.origin.x + (slideFrameBegin + 15. - frameIndex - 1.) / 15. * -frameWidthOneHalf;
				ZPLogDebug(@"#1 translationX:%.0f", translationX);
				imageSlomoCrop = [imageSlomoCrop imageByApplyingTransform:CGAffineTransformMakeTranslation(translationX, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:imageSlomoCrop forKey:kCIInputImageKey];
			} else if (frameIndex < (slideFrameBegin + 30)) {
				// second half slide in
				CGFloat translationX = -weakSelf.ciImageSecondHalf.extent.origin.x + (1. - (slideFrameBegin + 30. - frameIndex - 1.) / 15.) * frameWidthOneHalf;
				ZPLogDebug(@"#2 translationX:%.0f", translationX);
				CIImage *secondHalf = [weakSelf.ciImageSecondHalf imageByApplyingTransform:CGAffineTransformMakeTranslation(translationX, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:secondHalf forKey:kCIInputImageKey];
				imageBG = weakSelf.compositingFilter.outputImage;
				
				imageSlomoCrop = [imageSlomoCrop imageByApplyingTransform:CGAffineTransformMakeTranslation(-frameWidthOneFourth, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:imageSlomoCrop forKey:kCIInputImageKey];
			} else if (frameIndex < (slideFrameEnd - framesToExpand)) {
				// first & second half
				CGFloat translationX = -weakSelf.ciImageSecondHalf.extent.origin.x + frameWidthOneHalf;
				ZPLogDebug(@"#3 translationX:%.0f", translationX);
				CIImage *secondHalf = [weakSelf.ciImageSecondHalf imageByApplyingTransform:CGAffineTransformMakeTranslation(translationX, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:secondHalf forKey:kCIInputImageKey];
				imageBG = weakSelf.compositingFilter.outputImage;
				
				imageSlomoCrop = [imageSlomoCrop imageByApplyingTransform:CGAffineTransformMakeTranslation(-frameWidthOneFourth, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:imageSlomoCrop forKey:kCIInputImageKey];
			} else {
				// first half expand to fullscreen
				CGFloat translationX = -weakSelf.ciImageSecondHalf.extent.origin.x + frameWidthOneHalf;
				ZPLogDebug(@"#3 translationX:%.0f", translationX);
				CIImage *secondHalf = [weakSelf.ciImageSecondHalf imageByApplyingTransform:CGAffineTransformMakeTranslation(translationX, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:secondHalf forKey:kCIInputImageKey];
				imageBG = weakSelf.compositingFilter.outputImage;
				
				CGFloat frames = (CGFloat)(slideFrameEnd - frameIndex);
				if (frames < 0) {
					frames = 0;
				}
				CGFloat widthToExpand = (framesToExpand - frames) / framesToExpand * frameWidthOneHalf;
				CGFloat width = frameWidthOneHalf + widthToExpand;
				CIImage *imageSlomoExpand = [imageSlomo imageByCroppingToRect:CGRectMake((frameSize.width - width) / 2, 0, width, frameSize.height)];
				translationX = -imageSlomoExpand.extent.origin.x;
				ZPLogDebug(@"#4 translationX:%.0f, width:%.0f", translationX, width);
				imageSlomoExpand = [imageSlomoExpand imageByApplyingTransform:CGAffineTransformMakeTranslation(translationX, 0)];
				[weakSelf.compositingFilter setValue:imageBG forKey:kCIInputBackgroundImageKey];
				[weakSelf.compositingFilter setValue:imageSlomoExpand forKey:kCIInputImageKey];
			}
			
			CIImage *filteredImage = weakSelf.compositingFilter.outputImage;
			return filteredImage;
		} else {
			return [images firstObject];
		}
	};
	BSEffect2FilterBlock oldTVFilterBlock = ^CIImage * (NSArray *images, CGSize frameSize, NSUInteger frameIndex) {
		if (images.count > 0) {
			CGFloat rollPercent = 0;
			if (frameIndex <= 190) {
				rollPercent = .07;
			} else if (frameIndex <= 193) {
				rollPercent = .93;
			} else if (frameIndex <= 199) {
				rollPercent = .07;
			} else if (frameIndex <= 202) {
				rollPercent = .93;
			} else if (frameIndex <= 245) {
				rollPercent = 0;
			} else if (frameIndex <= 407) {
				rollPercent = .93;
			} else {
				rollPercent = .93;
			}
			weakSelf.oldTVFilter.rollPercent = rollPercent;
			
			[weakSelf.oldTVFilter setValue:[images firstObject] forKey:kCIInputImageKey];
			CIImage *filteredImage = weakSelf.oldTVFilter.outputImage;
			return filteredImage;
		} else {
			return nil;
		}
	};
	
	_filters = [NSMutableDictionary dictionary];
	for (NSUInteger i = slideFrameBegin; i <= slideFrameEnd; i++) {
		_filters[@(i)] = splitFilterBlock;
	}
	[self _addTVFilterBlock:oldTVFilterBlock atFrame:188 duration:6];
	[self _addTVFilterBlock:oldTVFilterBlock atFrame:197 duration:6];
	[self _addTVFilterBlock:oldTVFilterBlock atFrame:245 duration:6];
	[self _addTVFilterBlock:oldTVFilterBlock atFrame:407 duration:4];
	[self _addTVFilterBlock:oldTVFilterBlock atFrame:415 duration:4];
	
	_indexOfLastFilterFrame = 14 * kRenderedVideoFrameRate;
	_alphaToDimPerFrame = 1. / (kRenderedVideoDuration * kRenderedVideoFrameRate - _indexOfLastFilterFrame - 1);
	_filters[@(_indexOfLastFilterFrame)] = alphaFilterBlock;
}

- (void)_addTVFilterBlock:(BSEffect2FilterBlock)oldTVFilterBlock atFrame:(NSUInteger)atFrame duration:(NSUInteger)duration {
	for (NSUInteger i = 0; i < duration; i++) {
		_filters[@(atFrame + i)] = oldTVFilterBlock;
	}
}

- (CIImage *)_filterAlpha:(CGFloat)alpha withImage:(CIImage *)filteredImage {
	CGFloat rgba[4] = {0.0, 0.0, 0.0, alpha};
	[_alphaFilter setValue:[CIVector vectorWithValues:rgba count:4] forKey:@"inputAVector"];
	[_alphaFilter setValue:filteredImage forKey:kCIInputImageKey];
	return _alphaFilter.outputImage;
}

- (CIImage *)processVideoFrameWithImages:(NSArray *)images frameSize:(CGSize)frameSize atIndex:(NSUInteger)index {
	if (images.count == 0) {
		return nil;
	}
	
	ZPLogDebug(@"frame index:%i, video count:%i", (int)index, (int)images.count);
	BSEffect2FilterBlock block;
	if (index > _indexOfLastFilterFrame) {
		block = _filters[@(_indexOfLastFilterFrame)];
	}
	else {
		block = _filters[@(index)];
	}
	CIImage *filteredImage = block ? block(images, frameSize, index) : [images lastObject];
	
	return filteredImage;
}

@end
