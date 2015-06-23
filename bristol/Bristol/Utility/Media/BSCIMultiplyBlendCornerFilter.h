//
//  BSCIMultiplyBlendCornerFilter.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIBaseFilter.h"

typedef NS_ENUM (NSUInteger, BSCIMultiplyBlendCorner) {
	BSCIMultiplyBlendCornerNone = 0,
	BSCIMultiplyBlendCornerTL = 1 << 0,
	    BSCIMultiplyBlendCornerTR = 1 << 1,
	    BSCIMultiplyBlendCornerBR = 1 << 2,
	    BSCIMultiplyBlendCornerBL = 1 << 3,
};

@interface BSCIMultiplyBlendCornerFilter : BSCIBaseFilter

@property (nonatomic, strong) CIColor *color; // defaults to (.73, .87, .04, 1)
@property (nonatomic, assign) BSCIMultiplyBlendCorner blendCorner;

@end
