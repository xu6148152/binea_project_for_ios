//
//  ZPVideoWriter.h
//  ZPVideo
//
//  Created by Guichao Huang (Gary) on 10/8/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ZPVideoShared.h"

typedef void (^ZPVideoCapturerRecordFinishCallback) (BOOL recordedSuccessfully, NSURL *fileUrl, NSError *error);


@interface ZPVideoWriter : NSObject

- (instancetype)initWithCaptureSession:(AVCaptureSession *)captureSession;

@property (nonatomic, assign, readonly) ZPVideoStatus status;
@property (nonatomic, assign, readonly) CMVideoDimensions videoDimensions;
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

- (void)cameraDidRotate;

- (void)startRecordingWithMaxRecordedDuration:(float)maxRecordedDuration loop:(BOOL)loop eachCompletionCallback:(ZPVideoCapturerRecordFinishCallback)eachCompletionCallback allCompletionCallback:(ZPErrorBlock)allCompletionCallback;

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne;

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion;

@end


@interface ZPSystemVideoWriter : ZPVideoWriter

@property (nonatomic, strong, readonly) AVCaptureMovieFileOutput *captureMovieFileOutput;

@end


@interface ZPCustomVideoWriter : ZPVideoWriter

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong, readonly) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong, readonly) AVCaptureAudioDataOutput *audioOutput;

@end
