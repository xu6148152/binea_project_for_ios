//
//  ZPVideoCapturer.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/4/14.
//
//

#import "ZPVideoCapturer.h"
#import "ZPVideoMerger.h"
#import "ZPVideoWriter.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

// Set Logging Component
#undef ZPLogComponent
#define ZPLogComponent lcl_cVideo

NSString *getPathOfUrl(NSURL *url) {
	NSString *path = url.isFileURL ? url.path : url.absoluteString;
	return path;
}

NSString *getFileNameOfUrl(NSURL *url) {
	NSString *path = getPathOfUrl(url);
	return [path lastPathComponent];
}

#pragma mark - ZPVideoCapturer -
@interface ZPVideoCapturer ()
{
	dispatch_queue_t _sessionQueue;

	AVCaptureSession *_captureSession;
	AVCaptureDeviceInput *_audioDeviceInput;

	AVCaptureStillImageOutput *_stillImageOutput;
	AVCaptureVideoPreviewLayer *_previewLayer;

	UITapGestureRecognizer *_tapGesture;
	UIBackgroundTaskIdentifier _runningTask;

	BOOL _startCaptureSessionOnEnteringForeground;
	BOOL _directAppendSampleBufferToFile;
	BOOL _isClipForward;
	BOOL _startNewOne;

	NSUInteger _recordingDuration;
	NSDate *_datePivotToShiftTo;
	ZPQueue *_queueRecordedVideoUrl;
	ZPVideoOutputUrlCallback _outputUrlCallback;
	ZPVideoStopRecordCallback _didStopRecordCallback;
	ZPVideoStopRecordCallback _didStopClipCallback;

	ZPVideoWriter *_videoWriter;
	ZPVideoStatus _status;

	CMMotionManager *_motionManager;
}
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;

@end


@implementation ZPVideoCapturer
@synthesize status = _status;

- (id)init {
	self = [super init];
	if (self) {
		NSError *err = nil;
		[[NSFileManager defaultManager] removeItemAtPath:[ZPVideoShared getVideoTmpPath] error:&err]; //remove all temp videos
		if (err) {
			ZPLogError(@"remove video tmp folder error:\n%@", err);
        }
        
        _previewView = [[ZPVideoCapturerPreviewView alloc] init];
        _previewLayer = (AVCaptureVideoPreviewLayer *)_previewView.layer;
        _previewLayer.contentsGravity = kCAGravityResizeAspectFill;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

		_runningTask = UIBackgroundTaskInvalid;
		_sessionQueue = dispatch_queue_create("com.zepp.videoCapturer.session", DISPATCH_QUEUE_SERIAL);

		_motionManager = [[CMMotionManager alloc] init];
		_motionManager.accelerometerUpdateInterval = 0.01;
		[_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
			[_motionManager stopAccelerometerUpdates];
		}];

		[self _setupCaptureSession];
        
		[self setSessionPreset:AVCaptureSessionPresetHigh];
	}
	return self;
}

- (void)dealloc {
	[self _removeFrameRateObserveForDevice:_videoDeviceInput.device];
	[self teardownSession];
	ZPLogDebug(@"ZPVideoCapturer dealloc");
}

- (BOOL)isRecording {
	if (_videoWriter.status != ZPVideoStatusIdle)
		return YES;
	else
		return _status != ZPVideoStatusIdle;
}

- (ZPVideoStatus)status {
	if (_videoWriter.status != ZPVideoStatusIdle)
		return _videoWriter.status;
	else
		return _status;
}

- (CGSize)videoDimension {
	return CGSizeMake(_videoWriter.videoDimensions.width, _videoWriter.videoDimensions.height);
}

- (AVCaptureDevicePosition)captureDevicePosition {
	return [_videoDeviceInput.device position];
}

- (void)setSessionPreset:(NSString *)sessionPreset {
	if (![_captureSession canSetSessionPreset:sessionPreset]) {
		ZPLogError(@"sessionPreset:%@ is not supported for this device.", sessionPreset);
		return;
	}

	if (_sessionPreset != sessionPreset) {
		_sessionPreset = sessionPreset;
		ZPLogDebug(@"new sessionPreset:%@", sessionPreset);

		_captureSession.sessionPreset = sessionPreset;
	}
}

- (BOOL)setFrameRate:(float)frameRate {
    BOOL success = NO;
    AVCaptureDevice *captureDevice = _videoDeviceInput.device;
    AVCaptureDeviceFormat *bestFormat = nil;
    for (AVCaptureDeviceFormat *format in captureDevice.formats) {
        FourCharCode mediaSubType = CMFormatDescriptionGetMediaSubType(format.formatDescription);
        if (mediaSubType == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
            for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
                if (range.maxFrameRate > frameRate) {
                    bestFormat = format;
                }
            }
        }
    }
    if (bestFormat && [captureDevice lockForConfiguration:nil]) {
        [self _removeFrameRateObserveForDevice:captureDevice];
        
        captureDevice.activeFormat = bestFormat;
        captureDevice.activeVideoMaxFrameDuration = CMTimeMake(1, frameRate);
        captureDevice.activeVideoMinFrameDuration = CMTimeMake(1, frameRate);
        [captureDevice unlockForConfiguration];
        
        [self _addFrameRateObserveForDevice:captureDevice];
        
        success = YES;
    }
    
    if (success) {
        _frameRate = frameRate;
    }
    
    return success;
}

- (void)setMinFreeDiskSpaceLimit:(int64_t)minFreeDiskSpaceLimit {
	if (_minFreeDiskSpaceLimit != minFreeDiskSpaceLimit) {
		_minFreeDiskSpaceLimit = minFreeDiskSpaceLimit;

		if ([_videoWriter isKindOfClass:[ZPSystemVideoWriter class]]) {
			((ZPSystemVideoWriter *)_videoWriter).captureMovieFileOutput.minFreeDiskSpaceLimit = minFreeDiskSpaceLimit;
		}
	}
}

- (void)setRecordingOrientation:(AVCaptureVideoOrientation)recordingOrientation {
	_recordingOrientation = recordingOrientation;
	[[_previewLayer connection] setVideoOrientation:recordingOrientation];
	//[_videoWriter setVideoOrientation:recordingOrientation];
}

- (void)setEnableCaptureStillImage:(BOOL)enableCaptureStillImage {
	if (_enableCaptureStillImage != enableCaptureStillImage) {
		_enableCaptureStillImage = enableCaptureStillImage;

		if (enableCaptureStillImage) {
			_stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
			if ([_captureSession canAddOutput:_stillImageOutput]) {
				[_stillImageOutput setOutputSettings:@{ AVVideoCodecKey : AVVideoCodecJPEG }];
				[_captureSession addOutput:_stillImageOutput];
			}
		}
		else {
			[_captureSession removeOutput:_stillImageOutput];
		}
	}
}

- (void)setEnableTapToFocusAndExpose:(BOOL)enableTapToFocusAndExpose {
	if (_enableTapToFocusAndExpose != enableTapToFocusAndExpose) {
		_enableTapToFocusAndExpose = enableTapToFocusAndExpose;

		if (enableTapToFocusAndExpose) {
			_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_focusAndExposeTap:)];
			[_previewView addGestureRecognizer:_tapGesture];
		}
		else {
			[_previewView removeGestureRecognizer:_tapGesture];
		}
	}
}

- (void)setEnableAudio:(BOOL)enableAudio {
	if (_enableAudio != enableAudio) {
		_enableAudio = enableAudio;

		if (enableAudio) {
			AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
			_audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
			if ([_captureSession canAddInput:_audioDeviceInput]) {
				[_captureSession addInput:_audioDeviceInput];
			}
		}
		else {
			[_captureSession removeInput:_audioDeviceInput];
		}
	}
}

- (void)setVideoWriterClass:(Class)videoWriterClass {
	if (videoWriterClass) {
		NSAssert([videoWriterClass isSubclassOfClass:[ZPVideoWriter class]], @"videoWriterClass must be subclass of ZPVideoWriter");
	}
	if (_videoWriterClass != videoWriterClass) {
		_videoWriterClass = videoWriterClass;

		_videoWriter = [[videoWriterClass alloc] initWithCaptureSession:_captureSession];
		if ([_videoWriter isKindOfClass:[ZPCustomVideoWriter class]]) {
			((ZPCustomVideoWriter *)_videoWriter).videoInput = _videoDeviceInput;
		}
	}
}

- (void)setVideoDeviceInput:(AVCaptureDeviceInput *)videoDeviceInput {
	if (_videoDeviceInput != videoDeviceInput) {
		[self _removeFrameRateObserveForDevice:_videoDeviceInput.device];
		[self _addFrameRateObserveForDevice:videoDeviceInput.device];

		_videoDeviceInput = videoDeviceInput;

		if ([_videoWriter isKindOfClass:[ZPCustomVideoWriter class]]) {
			((ZPCustomVideoWriter *)_videoWriter).videoInput = _videoDeviceInput;
		}
	}
}

#pragma mark - KVO
- (void)_addFrameRateObserveForDevice:(AVCaptureDevice *)videoDevice {
    if (_isRunning) {
        [videoDevice addObserver:self forKeyPath:@"activeVideoMinFrameDuration" options:0 context:NULL];
    }
}

- (void)_removeFrameRateObserveForDevice:(AVCaptureDevice *)videoDevice {
    @try {
        [videoDevice removeObserver:self forKeyPath:@"activeVideoMinFrameDuration" context:NULL];
    }
    @catch (NSException *exception) {
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"activeVideoMinFrameDuration"]) {
        // NOTE: remove KVO in the next run loop to avoid crash with: NSKVOPendingNotificationRelease EXC_BAD_ACCESS
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setFrameRate:_frameRate];
        });
	}
}

#pragma mark - Capture Session -

- (void)_setupCaptureSession {
	if (_captureSession) {
		return;
	}

	_captureSession = [[AVCaptureSession alloc] init];
    
    _previewView.session = _captureSession;

	self.disableFocusAndExposeWhileRecording = YES;
	self.enableTapToFocusAndExpose = YES;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_captureSessionNotification:) name:nil object:_captureSession];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];

	// Audio
	_enableAudio = YES;
	self.enableAudio = NO;

	// Video
	AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
	self.videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
	if ([_captureSession canAddInput:_videoDeviceInput]) {
		[_captureSession addInput:_videoDeviceInput];
	}

	[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];

	self.recordingOrientation = (AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation;

    if (_frameRate == 0) {
        [self setFrameRate:30];
    } else {
        [self setFrameRate:_frameRate];
    }
	// TODO: not work
//	if (_videoInput.ports.count > 0) {
//		AVCaptureInputPort *port = [_videoInput.ports objectAtIndex:0];
//		CMFormatDescriptionRef formatDescription = port.formatDescription;
//		CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
//		_videoDimension = CGSizeMake(dimensions.width, dimensions.height);
//	}
}

- (void)startSession {
	@synchronized(self)
	{
		if (_isRunning)
			return;
		_isRunning = YES;
	}

	dispatch_async(_sessionQueue, ^{
	    [self _checkDeviceAuthorizationStatus];
	    [self _setupCaptureSession];
        
        self.videoWriterClass = [ZPSystemVideoWriter class];
        
	    [_captureSession startRunning];

	    _runningTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^{
	        ZPLogDebug(@"video capture background task expired");
		}];
	});
}

- (void)_stopSessionWithAdditionWork:(void (^)(void))work {
    @synchronized(self)
    {
        if (!_isRunning)
			return;
		_isRunning = NO;
    }
	
    dispatch_async(_sessionQueue, ^{
        [_captureSession stopRunning];
        ZPInvokeBlock(work);
        
        [self _stopRecordingWithStartNewOne:NO error:nil];
        self.videoWriterClass = nil;
        
        [[UIApplication sharedApplication] endBackgroundTask:_runningTask];
        _runningTask = UIBackgroundTaskInvalid;
    });
}

- (void)stopSession {
    [self _stopSessionWithAdditionWork:NULL];
}

- (void)teardownSession {
    if (_captureSession) {
        [self _stopSessionWithAdditionWork:^{
            _previewView.session = nil;
            _captureSession = nil;
        }];

		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
}

- (void)_setNeedRestartSession {
	// Since we can't resume running while in the background we need to remember this for next time we come to the foreground
	if (_isRunning)
		_startCaptureSessionOnEnteringForeground = YES;
}

- (void)_handleRecoverableCaptureSessionRuntimeError:(NSError *)error {
	if (_isRunning) {
		[_captureSession startRunning];
	}
}

- (void)_handleNonRecoverableCaptureSessionRuntimeError:(NSError *)error {
	_isRunning = NO;
	[self teardownSession];
}

- (void)_captureSessionNotification:(NSNotification *)notification {
	dispatch_async(_sessionQueue, ^{
	    NSError *error = [[notification userInfo] objectForKey:AVCaptureSessionErrorKey];
	    if ([[notification name] isEqualToString:AVCaptureSessionWasInterruptedNotification]) {
	        ZPLogDebug(@"session interrupted");

	        [self _setNeedRestartSession];
		}
	    else if ([[notification name] isEqualToString:AVCaptureSessionInterruptionEndedNotification]) {
	        ZPLogDebug(@"session interruption ended");
		}
	    else if ([[notification name] isEqualToString:AVCaptureSessionRuntimeErrorNotification]) {
	        [self _stopRecordingWithStartNewOne:NO error:error];

	        if (error.code == AVErrorDeviceIsNotAvailableInBackground) {
	            ZPLogDebug(@"device not available in background");

	            [self _setNeedRestartSession];
			}
	        else if (error.code == AVErrorMediaServicesWereReset) {
	            ZPLogDebug(@"media services were reset");
				[self _handleRecoverableCaptureSessionRuntimeError:error];
			}
	        else {
				ZPLogCritical(@"fatal runtime error %@, code %i", error, (int)error.code);
				[self _handleRecoverableCaptureSessionRuntimeError:error];
//				[self _handleNonRecoverableCaptureSessionRuntimeError:error];
			}
		}
	    else if ([[notification name] isEqualToString:AVCaptureSessionDidStartRunningNotification]) {
	        ZPLogDebug(@"session started running");
		}
	    else if ([[notification name] isEqualToString:AVCaptureSessionDidStopRunningNotification]) {
	        ZPLogDebug(@"session stopped running");
		}
	});
}

- (void)_applicationWillEnterForeground {
	ZPLogDebug(@"%@ called", NSStringFromSelector(_cmd));

	dispatch_async(_sessionQueue, ^{
	    if (_startCaptureSessionOnEnteringForeground) {
	        ZPLogDebug(@"%@ manually restarting session", NSStringFromSelector(_cmd));

	        _startCaptureSessionOnEnteringForeground = NO;
	        if (_isRunning) {
	            [_captureSession startRunning];
			}
		}
	});
}

#pragma mark - Recording -
- (void)startRecordingToFileWithOutputUrlCallback:(ZPVideoOutputUrlCallback)outputUrlCallback recordCompletion:(ZPVideoStopRecordCallback)recordCompletion clipCompletion:(ZPVideoStopRecordCallback)clipCompletion {
	[self _detectDeviceOrientationWithCallback:^(AVCaptureVideoOrientation videoOrientation) {
		[self _startRecordingToFileWithOutputUrlCallback:outputUrlCallback durationToRecord:0 isClipForward:NO recordCompletion:recordCompletion clipCompletion:clipCompletion videoOrientation:videoOrientation];
	}];
}

- (void)startRecordingToFileWithOutputUrlCallback:(ZPVideoOutputUrlCallback)outputUrlCallback clipToDuration:(float)duration isClipForward:(BOOL)isClipForward recordCompletion:(ZPVideoStopRecordCallback)recordCompletion clipCompletion:(ZPVideoStopRecordCallback)clipCompletion {
	[self _detectDeviceOrientationWithCallback:^(AVCaptureVideoOrientation videoOrientation) {
		[self _startRecordingToFileWithOutputUrlCallback:outputUrlCallback durationToRecord:duration isClipForward:isClipForward recordCompletion:recordCompletion clipCompletion:clipCompletion videoOrientation:videoOrientation];
	}];
}

- (CGFloat)_freeDiskSpaceInBytes {
	long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
	static const long long SpaceCalibarate = 200 * 1024 * 1024; // 200MB, refer to http://stackoverflow.com/questions/9270027/iphone-free-space-left-on-device-reported-incorrectly-200-mb-difference
	if (freeSpace > SpaceCalibarate)
		freeSpace -= SpaceCalibarate;
	else
		freeSpace = 0;

	return freeSpace;
}

- (void)_detectDeviceOrientationWithCallback:(void(^)(AVCaptureVideoOrientation videoOrientation))callback {
	__block BOOL detected = NO;
	AVCaptureVideoOrientation currentOrientation = (AVCaptureVideoOrientation)[UIDevice currentDevice].orientation;
	if ([_motionManager isAccelerometerAvailable]) {
		[_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
			if (error) {
				ZPInvokeBlock(callback, currentOrientation);
			} else if (accelerometerData && !detected) {
				ZPLogDebug(@"startAccelerometerUpdatesToQueue (%f, %f, %f)", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
				[_motionManager stopAccelerometerUpdates];
				detected = YES;

				AVCaptureVideoOrientation orientation;

				if (fabs(accelerometerData.acceleration.y) < fabs(accelerometerData.acceleration.x)) {
					// landscape
					if (accelerometerData.acceleration.x > 0) {
						orientation = AVCaptureVideoOrientationLandscapeLeft;
					} else {
						orientation = AVCaptureVideoOrientationLandscapeRight;
					}
				} else {
					if (accelerometerData.acceleration.y > 0) {
						orientation = AVCaptureVideoOrientationPortraitUpsideDown;
					} else {
						orientation = AVCaptureVideoOrientationPortrait;
					}
				}

				ZPLogDebug(@"Got capture orientation %d", orientation);
				ZPInvokeBlock(callback, orientation);
			}
		}];
	} else {
		ZPInvokeBlock(callback, currentOrientation);
	}
}

- (void)_startRecordingToFileWithOutputUrlCallback:(ZPVideoOutputUrlCallback)outputUrlCallback durationToRecord:(NSInteger)duration isClipForward:(BOOL)isClipForward recordCompletion:(ZPVideoStopRecordCallback)recordCompletion clipCompletion:(ZPVideoStopRecordCallback)clipCompletion videoOrientation:(AVCaptureVideoOrientation)videoOrientation {
	@synchronized(self)
	{
		if (_videoWriter.status != ZPVideoStatusIdle) {
			ZPLogDebug(@"status:%i, don't need to start", (int)_videoWriter.status);
			return;
		}
		if ([self _freeDiskSpaceInBytes] < _minFreeDiskSpaceLimit) {
			NSError *error = [NSError errorWithDomain:AVFoundationErrorDomain code:AVErrorDiskFull userInfo:nil];
			ZPInvokeBlock(recordCompletion, nil, error);
			ZPInvokeBlock(clipCompletion, nil, error);
			return;
		}
	}

	NSAssert(outputUrlCallback, @"outputUrlCallback can not be nil");
	_outputUrlCallback = outputUrlCallback;
	_didStopRecordCallback = recordCompletion;
	_didStopClipCallback = clipCompletion;

	dispatch_async(_sessionQueue, ^{
		_queueRecordedVideoUrl = [[ZPQueue alloc] initWithMaxSize:2];
		_directAppendSampleBufferToFile = duration <= 0;
		if (_directAppendSampleBufferToFile)
			_recordingDuration = 0;
		else
			_recordingDuration = ABS(duration);
		_isClipForward = isClipForward;

		[_videoWriter setVideoOrientation:videoOrientation];
		[_videoWriter startRecordingWithMaxRecordedDuration:_recordingDuration loop:!_directAppendSampleBufferToFile eachCompletionCallback: ^(BOOL recordedSuccessfully, NSURL *fileUrl, NSError *errorRecord) {
			if (recordedSuccessfully) {
				NSURL *urlToDelete = [_queueRecordedVideoUrl enqueue:fileUrl];
				if (urlToDelete) {
					NSError *err = nil;
					[[NSFileManager defaultManager] removeItemAtURL:urlToDelete error:&err];
					if (err) {
						ZPLogError(@"remove overflow path error: %@\n%@", urlToDelete, err);
					}
					else {
						ZPLogDebug(@"remove overflow path success: %@", urlToDelete);
					}
				}
			}
		} allCompletionCallback: ^(NSError *errorRecord) {
			NSArray *urls = [_queueRecordedVideoUrl allElements];
			_queueRecordedVideoUrl = [[ZPQueue alloc] initWithMaxSize:2];
			
			NSURL *recordingUrl = _outputUrlCallback();
			[[NSFileManager defaultManager] removeItemAtURL:recordingUrl error:NULL];
			if (_directAppendSampleBufferToFile && (self.videoWriterClass == [ZPCustomVideoWriter class])) {
				NSError *err = nil;
				NSURL *fileUrl = [urls firstObject];
				[[NSFileManager defaultManager] moveItemAtURL:fileUrl toURL:recordingUrl error:&err];
				if (err) {
					ZPLogError(@"move tmp path error: \nfrom: %@ \nto: %@ \nerror: %@", fileUrl, recordingUrl, err);
				}
				else {
					ZPLogDebug(@"move tmp path success: \nfrom: %@\nto: %@", fileUrl, recordingUrl);
				}
				
				dispatch_async(dispatch_get_main_queue(), ^{
					_status = ZPVideoStatusFinishedRecording;
					ZPInvokeBlock(_didStopRecordCallback, recordingUrl, errorRecord);
					
					_status = ZPVideoStatusCliping;
					ZPInvokeBlock(_didStopClipCallback, recordingUrl, nil);
					_status = ZPVideoStatusIdle;
				});
			}
			else {
				dispatch_async(dispatch_get_main_queue(), ^{
					_status = ZPVideoStatusFinishedRecording;
					ZPInvokeBlock(_didStopRecordCallback, recordingUrl, errorRecord);
					
					ZPLogDebug(@"urls to merge:\n%@", urls);
					_status = ZPVideoStatusCliping;
					
					void (^mergeDidFinish)() = ^(NSError *errorClip) {
						if (errorClip) {
							ZPLogError(@"merge video did error:%@", errorClip);
						}
						else {
							ZPLogDebug(@"merge video did success:%@", recordingUrl);
						}
						
						for (NSURL * url in urls) {
							[[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
						}
						
						NSError *error = errorClip;
						if ([[NSFileManager defaultManager] fileExistsAtPath:getPathOfUrl(recordingUrl)]) {
							error = nil;
						}
						ZPInvokeBlock(_didStopClipCallback, recordingUrl, error);
						_status = ZPVideoStatusIdle;
					};

					if (urls.count <= 1 && _directAppendSampleBufferToFile) {
						if (urls.count == 1) {
							[[NSFileManager defaultManager] moveItemAtURL:[urls firstObject] toURL:recordingUrl error:NULL];
						}

						mergeDidFinish(errorRecord);
					}
					else {
						NSTimeInterval shiftDuration = 0;
						if (_datePivotToShiftTo) {
							NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
							shiftDuration = now - [_datePivotToShiftTo timeIntervalSince1970];
						}
						[ZPVideoMerger mergeVideoWithUrls:urls outputURL:recordingUrl presetName:AVAssetExportPresetPassthrough constrainDuration:_recordingDuration shiftDuration:shiftDuration isForward:NO progressCallback: ^(float progress) {
						} completionCallback: ^(NSError *errorClip) {
							if (errorClip.code == -11838) {
								[ZPVideoMerger mergeVideoWithUrls:urls outputURL:recordingUrl presetName:AVAssetExportPreset1280x720 constrainDuration:_recordingDuration shiftDuration:shiftDuration isForward:NO progressCallback: ^(float progress) {
								} completionCallback: ^(NSError *errorClip) {
									mergeDidFinish(errorClip);
								}];
							}
							else {
								mergeDidFinish(errorClip);
							}
						}];
					}
				});
			}
		}];
	});
}

- (void)_stopRecordingWithStartNewOne:(BOOL)startNewOne error:(NSError *)errorRecordInterrupt {
	@synchronized(self)
	{
		if (_videoWriter.status != ZPVideoStatusRecording) {
			return;
		}
		if (_directAppendSampleBufferToFile)
			_startNewOne = NO;
		else
			_startNewOne = startNewOne;
	}

	dispatch_async(_sessionQueue, ^{
	    [_videoWriter stopRecordingWithStartNewOne:_startNewOne];
	});
}

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne {
	[self stopRecordingWithStartNewOne:startNewOne datePivotToShiftTo:nil];
}

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne datePivotToShiftTo:(NSDate *)datePivotToShiftTo {
	@synchronized(self)
	{
		if (_videoWriter.status != ZPVideoStatusRecording) {
			return;
		}
	}

	_datePivotToShiftTo = datePivotToShiftTo;
	[self _stopRecordingWithStartNewOne:startNewOne error:nil];
}

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion {
	[_videoWriter cancelRecordingWithCompletion:completion];
}

#pragma mark - Device Configuration -

- (void)rotateCameraWithCompletion:(ZPBOOLBlock)completion {
	if (!_deviceAuthorized) {
		ZPInvokeBlock(completion, NO);
		return;
	}

	dispatch_async(_sessionQueue, ^{
	    AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
	    AVCaptureDevicePosition currentPosition = [_videoDeviceInput.device position];

	    switch (currentPosition) {
			case AVCaptureDevicePositionUnspecified:
				preferredPosition = AVCaptureDevicePositionBack;
				break;

			case AVCaptureDevicePositionBack:
				preferredPosition = AVCaptureDevicePositionFront;
				break;

			case AVCaptureDevicePositionFront:
				preferredPosition = AVCaptureDevicePositionBack;
				break;
		}

	    AVCaptureDevice *videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
	    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];

	    BOOL success = NO;
	    [_captureSession beginConfiguration];

	    [_captureSession removeInput:_videoDeviceInput];

	    if (![_captureSession canAddInput:videoDeviceInput]) {
	        [self setSessionPreset:AVCaptureSessionPresetHigh];
		}

	    if ([_captureSession canAddInput:videoDeviceInput]) {
	        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
	        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];

	        self.videoDeviceInput = videoDeviceInput;
	        [_captureSession addInput:videoDeviceInput];

	        success = YES;
		}
	    else {
	        [_captureSession addInput:_videoDeviceInput];

	        success = NO;
		}

	    [_captureSession commitConfiguration];

	    [_videoWriter cameraDidRotate];

	    ZPLogDebug(@"camera did rotate");
	    if (completion) {
	        dispatch_async(dispatch_get_main_queue(), ^{
	            completion(success);
			});
		}
	});
}

- (void)captureStillImageWithCompletion:(ZPImageBlock)completion {
	if (!_stillImageOutput || !_deviceAuthorized) {
		ZPInvokeBlock(completion, nil);
		return;
	}

	dispatch_async(_sessionQueue, ^{
	    // Update the orientation on the still image output video connection before capturing.
	    [[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[_previewLayer connection] videoOrientation]];

	    // Capture a still image.
	    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler: ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
	        UIImage *image = nil;
	        if (imageDataSampleBuffer) {
	            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
	            image = [[UIImage alloc] initWithData:imageData];
			}
	        ZPInvokeBlock(completion, image);
		}];
	});
}

- (void)_focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer {
	if (self.isRecording && self.disableFocusAndExposeWhileRecording) {
	}
	else {
		CGPoint devicePoint = [_previewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
		[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
	}
}

- (void)_subjectAreaDidChange:(NSNotification *)notification {
	if (self.isRecording && self.disableFocusAndExposeWhileRecording) {
	}
	else {
		CGPoint devicePoint = CGPointMake(.5, .5);
		[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
	}
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
	dispatch_async(_sessionQueue, ^{
	    NSError *error = nil;
	    AVCaptureDevice *device = _videoDeviceInput.device;
	    if ([device lockForConfiguration:&error]) {
	        if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
	            [device setFocusMode:focusMode];
	            [device setFocusPointOfInterest:point];
			}
	        if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
	            [device setExposureMode:exposureMode];
	            [device setExposurePointOfInterest:point];
			}
	        [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
	        [device unlockForConfiguration];
		}
	    else {
	        ZPLogError(@"%@", error);
		}
	});
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
	AVCaptureDevice *device = [_videoDeviceInput device];
	if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
		NSError *error = nil;
		if ([device lockForConfiguration:&error]) {
			[device setFlashMode:flashMode];
			[device unlockForConfiguration];
		}
		else {
			ZPLogError(@"%@", error);
		}
	}
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
	AVCaptureDevice *captureDevice = [devices firstObject];

	for (AVCaptureDevice *device in devices) {
		if ([device position] == position) {
			captureDevice = device;
			break;
		}
	}

	return captureDevice;
}

#pragma mark UI

- (void)runCaptureStillImageAnimation {
	dispatch_async(dispatch_get_main_queue(), ^{
	    [_previewLayer setOpacity:0.0];
	    [UIView animateWithDuration:.25 animations: ^{
	        [_previewLayer setOpacity:1.0];
		}];
	});
}

- (void)_checkDeviceAuthorizationStatus {
	if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
		    _deviceAuthorized = granted;
		}];
	}
	else {
		_deviceAuthorized = YES;
	}
}

@end
