//
//  BSCIBaseFilter.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCIBaseFilter.h"

@implementation BSCIBaseFilter

+ (instancetype)filter {
	return (BSCIBaseFilter *)[CIFilter filterWithName:NSStringFromClass([self class])];
}

@end
