//
//  BSCIBaseFilter.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface BSCIBaseFilter : CIFilter

@property (nonatomic, strong) CIImage *inputImage;

+ (instancetype)filter;

@end
