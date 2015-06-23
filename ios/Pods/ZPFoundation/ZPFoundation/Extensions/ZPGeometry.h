//
//  ZPGeometry.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline CGFloat
degrees2Radian(const CGFloat degrees)
{
    return degrees * M_PI / 180.0;
}

static inline CGFloat
radian2Degrees(const CGFloat redian)
{
    return redian * 180.0 / M_PI;
}

static inline CGFloat
kg2lbs(const CGFloat kg)
{
    return kg * 2.2046226218488;
}

static inline CGFloat
lbs2kg(CGFloat lbs)
{
    return lbs / 2.2046226218488;
}

static inline CGFloat
centimeter2feet(CGFloat centimeter)
{
    return centimeter / 30.48;
}

static inline CGFloat
feet2centimeter(CGFloat feet)
{
    return feet * 30.48;
}

static inline CGFloat
centimeter2inch(CGFloat centimeter)
{
    return centimeter / 2.54;
}

static inline CGFloat
inch2centimeter(CGFloat inch)
{
    return inch * 2.54;
}

static inline CGFloat
km2Mile(CGFloat km)
{
    return km * 0.62137119223733;
}

static inline CGFloat
mile2Km(CGFloat mile)
{
    return mile / 0.62137119223733;
}

static inline CGSize
sizeFitSizeInSize(CGSize size, CGSize inSize)
{
	CGFloat scale;
	CGSize  newsize = size;
	
	if (newsize.height && (newsize.height > inSize.height)) {
		scale = inSize.height / newsize.height;
		newsize.width *= scale;
		newsize.height *= scale;
	}
	
	if (newsize.width && (newsize.width >= inSize.width)) {
		scale = inSize.width / newsize.width;
		newsize.width *= scale;
		newsize.height *= scale;
	}
	
	return newsize;
}

static inline CGRect
rectCenterSizeInSize(CGSize aSize, CGSize inSize)
{
	CGSize size = sizeFitSizeInSize(aSize, inSize);
	float  dWidth = inSize.width - size.width;
	float  dHeight = inSize.height - size.height;
	
	return CGRectMake(dWidth / 2.0f, dHeight / 2.0f, size.width, size.height);
}

static inline CGRect
rectScaleAspectFillSizeInSize(CGSize size, CGSize inSize)
{
	CGFloat scalex = inSize.width / size.width;
	CGFloat scaley = inSize.height / size.height;
	CGFloat scale = MAX(scalex, scaley);
	
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
	
	float dwidth = ((inSize.width - width) / 2.0f);
	float dheight = ((inSize.height - height) / 2.0f);
	
	return CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
}

static inline CGRect
rectScaleAspectFitSizeInSize(CGSize size, CGSize inSize)
{
	CGFloat scalex = inSize.width / size.width;
	CGFloat scaley = inSize.height / size.height;
	CGFloat scale = MIN(scalex, scaley);
	
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
	
	float dwidth = ((inSize.width - width) / 2.0f);
	float dheight = ((inSize.height - height) / 2.0f);
	
	return CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
}
