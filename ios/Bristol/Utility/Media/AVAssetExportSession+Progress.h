//
//  AVAssetExportSession+Progress.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/10/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAssetExportSession (Progress)

- (void)exportAsynchronouslyWithProgress:(ZPFloatBlock)progressHandler completionHandler:(ZPVoidBlock)completionHandler;

@end
