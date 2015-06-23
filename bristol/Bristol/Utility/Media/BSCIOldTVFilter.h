//
//  BSCIOldTVFilter.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIBaseFilter.h"

@interface BSCIOldTVFilter : BSCIBaseFilter

@property (nonatomic, assign) CGFloat rollPercent; // [0, 1], roll from top to bottom, defaults to 0
@property (nonatomic, strong, readonly) CIFilter *lineScreenFilter;

@end
