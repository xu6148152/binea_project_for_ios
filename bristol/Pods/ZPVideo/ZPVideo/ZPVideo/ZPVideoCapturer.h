//
//  ZPVideoCapturer.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/4/14.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ZPVideoShared.h"
#import "ZPVideoCapturerPreviewView.h"

@interface ZPVideoCapturer : NSObject

@property (nonatomic, strong) NSString *sessionPreset;
@property (nonatomic, assign) AVCaptureVideoOrientation recordingOrientation;
@property (nonatomic, readonly) AVCaptureDevicePosition captureDevicePosition;
@property (nonatomic, strong, readonly) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, readonly) CGSize videoDimension;
@property (nonatomic, readonly) ZPVideoCapturerPreviewView *previewView;
@property (nonatomic, readonly) ZPVideoStatus status;

@property (nonatomic, readonly) float frameRate; // default is 30fps
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, readonly) BOOL isRecording;
@property (nonatomic, readonly) BOOL deviceAuthorized;
@property (nonatomic, assign) BOOL enableCaptureStillImage; // default is NO
@property (nonatomic, assign) BOOL enableTapToFocusAndExpose; // default is YES
@property (nonatomic, assign) BOOL disableFocusAndExposeWhileRecording; // default is YES
@property (nonatomic, assign) BOOL enableAudio; // default is NO
@property (nonatomic, assign) int64_t minFreeDiskSpaceLimit; // in bytes
@property (nonatomic, strong) Class videoWriterClass; // sub-class of ZPVideoWriter

- (void)startSession;
- (void)stopSession;
- (void)teardownSession;

- (void)rotateCameraWithCompletion:(ZPBOOLBlock)completion;
- (void)captureStillImageWithCompletion:(ZPImageBlock)completion;
- (void)runCaptureStillImageAnimation;

- (void)startRecordingToFileWithOutputUrlCallback:(ZPVideoOutputUrlCallback)callback recordCompletion:(ZPVideoStopRecordCallback)recordCompletion clipCompletion:(ZPVideoStopRecordCallback)clipCompletion;
- (void)startRecordingToFileWithOutputUrlCallback:(ZPVideoOutputUrlCallback)callback clipToDuration:(float)duration isClipForward:(BOOL)isClipForward recordCompletion:(ZPVideoStopRecordCallback)recordCompletion clipCompletion:(ZPVideoStopRecordCallback)clipCompletion;

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne;
- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne datePivotToShiftTo:(NSDate *)datePivotToShiftTo;

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion;

- (BOOL)setFrameRate:(float)frameRate;

- (void)setFlashMode:(AVCaptureFlashMode)flashMode;

@end
