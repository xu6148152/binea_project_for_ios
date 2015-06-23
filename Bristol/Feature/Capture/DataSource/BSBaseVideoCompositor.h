//
//  BSBaseVideoCompositor.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NSArray * (^BSFilterBlock)(CGSize frameSize, NSUInteger frameIndex);

@interface BSBaseVideoCompositor : NSObject <AVVideoCompositing>

@property(nonatomic, strong, readonly) AVVideoCompositionRenderContext *renderContext;
@property(nonatomic, strong, readonly) CIFilter *transformFilter;

- (NSValue *)transformToValue:(CGAffineTransform)transform;

// overwrite required
- (CIImage *)processVideoFrameWithImages:(NSArray *)images frameSize:(CGSize)frameSize atIndex:(NSUInteger)index;

@end
