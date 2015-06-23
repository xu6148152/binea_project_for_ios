//
//  BSCIImageView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIImageView.h"
#import "BSCoreImageManager.h"

@interface BSCIImageView() {
	CIContext *_CIContext;
}

@end

@implementation BSCIImageView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit {
	_CIContext = [BSCoreImageManager sharedManager].ciContext;
	
	self.context = [BSCoreImageManager sharedManager].eaglContext;
}

- (void)drawRect:(CGRect)rect {
	CIImage *image = _ciImage;
	if (image != nil) {
		CGRect extent = [image extent];
		
		if (_filterGroup != nil) {
			for (CIFilter *filter in _filterGroup) {
				if ([filter isKindOfClass:[CIFilter class]]) {
					[filter setValue:image forKey:kCIInputImageKey];
					image = [filter valueForKey:kCIOutputImageKey];
				}
			}
		}
		CGRect outputRect = [self processRect:rect withImageSize:extent.size contentScale:self.contentScaleFactor contentMode:self.contentMode];
		
		[_CIContext drawImage:image inRect:outputRect fromRect:extent];
	}
}

- (void)setCiImage:(CIImage *)ciImage {
	_ciImage = ciImage;
	
	[self setNeedsDisplay];
}

- (void)setFilterGroup:(NSArray *)filterGroup {
	_filterGroup = filterGroup;
	
	[self setNeedsDisplay];
}

- (void)setPreferredCIImageTransform:(CGAffineTransform)preferredCIImageTransform {
	self.transform = preferredCIImageTransform;
}

- (CGRect)processRect:(CGRect)rect withImageSize:(CGSize)imageSize contentScale:(CGFloat)contentScale contentMode:(UIViewContentMode)mode {
	rect = [self rect:rect byApplyingContentScale:contentScale];
	
	if (mode != UIViewContentModeScaleToFill) {
		CGFloat horizontalScale = rect.size.width / imageSize.width;
		CGFloat verticalScale = rect.size.height / imageSize.height;
		
		BOOL shouldResizeWidth = mode == UIViewContentModeScaleAspectFit ? horizontalScale > verticalScale : verticalScale > horizontalScale;
		BOOL shouldResizeHeight = mode == UIViewContentModeScaleAspectFit ? verticalScale > horizontalScale : horizontalScale > verticalScale;
		
		if (shouldResizeWidth) {
			CGFloat newWidth = imageSize.width * verticalScale;
			rect.origin.x = (rect.size.width / 2 - newWidth / 2);
			rect.size.width = newWidth;
		} else if (shouldResizeHeight) {
			CGFloat newHeight = imageSize.height * horizontalScale;
			rect.origin.y = (rect.size.height / 2 - newHeight / 2);
			rect.size.height = newHeight;
		}
	}
	
	return rect;
}

- (CGRect)rect:(CGRect)rect byApplyingContentScale:(CGFloat)scale {
	rect.origin.x *= scale;
	rect.origin.y *= scale;
	rect.size.width *= scale;
	rect.size.height *= scale;
	
	return rect;
}

@end
