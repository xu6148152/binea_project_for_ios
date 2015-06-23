//
//  UIImage+Resize.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UIImage+Resize.h"
#import "ZPGeometry.h"

@implementation UIImage (Resize)

- (UIImage *)imageFitInSize:(CGSize)size
{
	CGSize newSize = sizeFitSizeInSize(self.size, size);
	
	UIGraphicsBeginImageContextWithOptions(newSize, NO, self.scale);
	
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}

- (UIImage *)imageCenterInSize:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
	
	CGSize imageSize = self.size;
	float  dwidth = (size.width - imageSize.width) / 2.0f;
	float  dheight = (size.height - imageSize.height) / 2.0f;
	
	CGRect rect = CGRectMake(dwidth, dheight, imageSize.width, imageSize.height);
	[self drawInRect:rect];
	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}

- (UIImage *)imageFillInSize:(CGSize)size
{
	CGSize  imageSize = self.size;
	CGFloat scalex = size.width / imageSize.width;
	CGFloat scaley = size.height / imageSize.height;
	CGFloat scale = MAX(scalex, scaley);
	
	UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
	
	CGFloat width = imageSize.width * scale;
	CGFloat height = imageSize.height * scale;
	
	float dwidth = ((size.width - width) / 2.0f);
	float dheight = ((size.height - height) / 2.0f);
	
	CGRect rect = CGRectMake(dwidth, dheight, imageSize.width * scale, imageSize.height * scale);
	[self drawInRect:rect];
	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}

@end


@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
	return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

@end
