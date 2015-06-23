//
//  SCImageHolder.h
//  SCRecorder
//
//  Created by Simon CORSIN on 13/09/14.
//  Copyright (c) 2014 rFlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@protocol CIImageRenderer <NSObject>

/**
   The CIImage to display
 */
@property (strong, nonatomic) CIImage *ciImage;

@optional

/**
   The preferred transform for rendering the CIImage
 */
@property (assign, nonatomic) CGAffineTransform preferredCIImageTransform;

/**
   Some objects such as the SCPlayer may need to get a frame.
 */
@property (readonly, nonatomic) CGRect frame;

@end
