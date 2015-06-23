//
//  BSCIDistortFilter.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIBaseFilter.h"

@interface BSCIDistortFilter : BSCIBaseFilter

@property(nonatomic, assign) CGFloat horizontalDistortPercent; // [0, .3]
@property(nonatomic, assign) BOOL randomDistortInEachFrame; // defaults to YES

@end
