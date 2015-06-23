//
//  BSCIImageView.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <CoreImage/CoreImage.h>
#import <Foundation/Foundation.h>
#import "CIImageRenderer.h"

@interface BSCIImageView : GLKView <CIImageRenderer>

@property (strong, nonatomic) NSArray *filterGroup;
@property (strong, nonatomic) CIImage *ciImage;

@end
