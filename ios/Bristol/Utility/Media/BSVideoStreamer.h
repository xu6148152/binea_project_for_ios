//
//  BSVideoStreamer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BSVideoStreamer : NSObject

+ (AVURLAsset *)streamVideoForUrl:(NSURL *)url progress:(ZPFloatBlock)progress success:(ZPDataBlock)success faild:(ZPErrorBlock)faild;

@end
