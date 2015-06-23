//
//  ZPVideo.h
//  ZPVideo
//
//  Created by Guichao Huang (Gary) on 10/5/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPFoundation.h"

typedef void (^ZPVideoStopRecordCallback) (NSURL *fileUrl, NSError *error);
typedef NSURL * (^ZPVideoOutputUrlCallback) ();

typedef NS_ENUM (NSInteger, ZPVideoStatus) {
	ZPVideoStatusIdle = 0,
	ZPVideoStatusPreparingToRecord,
	ZPVideoStatusRecording,
	ZPVideoStatusFinishingRecording,
	ZPVideoStatusFinishedRecording,
	ZPVideoStatusCliping,
	ZPVideoStatusCancelingRecording,
};

@interface ZPVideoShared : NSObject

+ (NSString *)getVideoTmpPath;
+ (NSURL *)generateRandomTempFile;

@end
