//
//  BSCIMultiplyBlendFrameFilter.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIBaseFilter.h"

@interface BSCIMultiplyBlendFrameFilter : BSCIBaseFilter

@property (nonatomic, strong) CIColor *color; // defaults to (.73, .87, .04, 1)
@property (nonatomic, assign) CGRect frameNormalized; // in the coordinate space of UIKit

@end
