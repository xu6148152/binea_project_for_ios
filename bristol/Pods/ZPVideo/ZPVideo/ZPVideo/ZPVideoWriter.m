//
//  ZPVideoWriter.m
//  ZPVideo
//
//  Created by Guichao Huang (Gary) on 10/8/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPVideoWriter.h"
#import "ZPQueue.h"

// Set Logging Component
#undef ZPLogComponent
#define ZPLogComponent lcl_cVideo

#pragma mark - ZPVideoWriter -
@interface ZPVideoWriter ()
{
	@protected
	AVCaptureSession *_captureSession;
	AVCaptureVideoOrientation _videoOrientation;
	ZPVideoCapturerRecordFinishCallback _eachCompletionCallback;
	ZPErrorBlock _allCompletionCallback;
	ZPVoidBlock _cancelRecordingCompletion;
	ZPVideoStatus _status;
	CMVideoDimensions _videoDimensions;
	CGAffineTransform _videoTransform;
	BOOL _loop;
	BOOL _needStop;
	BOOL _startNewOne;
	float _maxRecordedDuration;
}

@end

@implementation ZPVideoWriter
@synthesize videoOrientation = _videoOrientation;

- (instancetype)initWithCaptureSession:(AVCaptureSession *)captureSession {
	self = [super init];
	if (self) {
		_captureSession = captureSession;
	}
	return self;
}

- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
}

- (void)cameraDidRotate {
}

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion {
}

- (void)startRecordingWithMaxRecordedDuration:(float)maxRecordedDuration loop:(BOOL)loop eachCompletionCallback:(ZPVideoCapturerRecordFinishCallback)eachCompletionCallback allCompletionCallback:(ZPErrorBlock)allCompletionCallback {
}

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne {
}

@end


#pragma mark - ZPSystemVideoWriter -
@interface ZPSystemVideoWriter () <AVCaptureFileOutputRecordingDelegate>

@end


@implementation ZPSystemVideoWriter
{
}

- (instancetype)initWithCaptureSession:(AVCaptureSession *)captureSession {
	self = [super initWithCaptureSession:captureSession];
	if (self) {
		_captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
		if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
			[_captureSession addOutput:_captureMovieFileOutput];

			AVCaptureConnection *connection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			if ([connection isVideoStabilizationSupported] && [connection respondsToSelector:@selector(preferredVideoStabilizationMode)])
				connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeStandard;
		}
		else {
			ZPLogError(@"can not add output: recorderSystemAddiction");
		}
	}
	return self;
}

- (void)dealloc {
	[_captureSession removeOutput:_captureMovieFileOutput];
	ZPLogDebug(@"ZPSystemVideoWriter dealloc");
}

- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
	AVCaptureConnection *connection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
	if ([connection isVideoOrientationSupported]) {
		[connection setVideoOrientation:videoOrientation];
		ZPLogDebug(@"connection:%@\n, videoOrientation:%i", [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo], (int)videoOrientation);
	}
}

- (void)_actuallyStart {
	AVCaptureConnection *connection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
	if (!connection.active) {
		NSString *message = @"no active capture connection to start record";
		ZPLogCritical(@"%@", message);
		ZPInvokeBlock(_allCompletionCallback, [NSError errorWithDomain:@"com.zepp.ZPVideo" code:0 userInfo:@{ NSLocalizedDescriptionKey:message }]);

		return;
	}

	@synchronized(self)
	{
		_status = ZPVideoStatusPreparingToRecord;
	}

	if (_maxRecordedDuration > 0) {
		_captureMovieFileOutput.maxRecordedDuration = CMTimeMake(_maxRecordedDuration, 1);
	}
	[_captureMovieFileOutput startRecordingToOutputFileURL:[ZPVideoShared generateRandomTempFile] recordingDelegate:self];
}

- (void)startRecordingWithMaxRecordedDuration:(float)maxRecordedDuration loop:(BOOL)loop eachCompletionCallback:(ZPVideoCapturerRecordFinishCallback)eachCompletionCallback allCompletionCallback:(ZPErrorBlock)allCompletionCallback {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusIdle)
			return;

		_needStop = NO;
		_startNewOne = NO;
	}

	_loop = loop;
	_maxRecordedDuration = maxRecordedDuration * 10; // decrease the opportunity of discard video frame. the bigger this param, the lower opportunity to appear, but the more disk to consume
	_eachCompletionCallback = eachCompletionCallback;
	_allCompletionCallback = allCompletionCallback;

	[self _actuallyStart];
}

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusRecording)
			return;

		_status = ZPVideoStatusFinishingRecording;
		_needStop = YES;
		_startNewOne = startNewOne;
	}

	[_captureMovieFileOutput stopRecording];
	ZPLogDebug(@"_captureMovieFileOutput stopRecording called");
}

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion {
	ZPLogDebug(@"cancelRecording did called");
	@synchronized(self)
	{
		if (_status == ZPVideoStatusIdle) {
			ZPInvokeBlock(completion);
			return;
		}

		_status = ZPVideoStatusCancelingRecording;
		_needStop = NO;
		_startNewOne = NO;
	}

	_cancelRecordingCompletion = completion;
	[_captureMovieFileOutput stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
CFAbsoluteTime startProcessingTime;
CFAbsoluteTime endProcessingTime;
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileUrl fromConnections:(NSArray *)connections {
	ZPLogDebug(@"didStartRecordingToOutputFileAtURL: %@", fileUrl);
	@synchronized(self)
	{
		_status = ZPVideoStatusRecording;
	}
	endProcessingTime = CFAbsoluteTimeGetCurrent();
	ZPLogDebug(@"missing video record duration: %.3f s", (endProcessingTime - startProcessingTime));
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileUrl fromConnections:(NSArray *)connections {
	ZPLogDebug(@"didPauseRecordingToOutputFileAtURL: %@", fileUrl);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileUrl fromConnections:(NSArray *)connections {
	ZPLogDebug(@"didResumeRecordingToOutputFileAtURL: %@", fileUrl);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileUrl fromConnections:(NSArray *)connections error:(NSError *)error {
	ZPLogDebug(@"willFinishRecordingToOutputFileAtURL: %@", fileUrl);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)fileUrl fromConnections:(NSArray *)connections error:(NSError *)error {
	ZPLogDebug(@"didFinishRecordingToOutputFileAtURL: %@, recording:%i, error:%@", fileUrl, _captureMovieFileOutput.recording, error);
	switch (_status) {
		case ZPVideoStatusCancelingRecording:
		{
			@synchronized(self)
			{
				_status = ZPVideoStatusIdle;
			}
			[[NSFileManager defaultManager] removeItemAtURL:fileUrl error:NULL];
			ZPLogDebug(@"cancelRecording did finish");
			ZPInvokeBlock(_cancelRecordingCompletion);
			break;
		}
		default:
		case ZPVideoStatusFinishingRecording:
		{
			startProcessingTime = CFAbsoluteTimeGetCurrent();
			
			dispatch_async(dispatch_get_main_queue(), ^{ // call back in next run loop to get correct state of _captureMovieFileOutput.recording
				ZPLogDebug(@"didFinishRecordingToOutputFileAtURL: %@, recording:%i", fileUrl, _captureMovieFileOutput.recording);
				BOOL recordedSuccessfully = YES;
				if ([error code] != noErr) {
					// A problem occurred: Find out if the recording was successful.
					// error may occure in AVErrorMaximumDurationReached, AVErrorMaximumFileSizeReached, AVErrorDiskFull, AVErrorDeviceWasDisconnected, AVErrorSessionWasInterrupted
					id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
					if (value) {
						recordedSuccessfully = [value boolValue];
					}
				}
				BOOL startNewOne = _startNewOne;
				if (error) {
					startNewOne = NO;
					_needStop = YES;
				}
				
				BOOL needStop;
				@synchronized(self)
				{
					_status = ZPVideoStatusIdle;
					needStop = _needStop;
					_needStop = NO;
				}
				
				if (startNewOne || (!needStop && _loop)) {
					[self _actuallyStart];
				}
				ZPInvokeBlock(_eachCompletionCallback, recordedSuccessfully, fileUrl, error);
				if (needStop) {
					ZPInvokeBlock(_allCompletionCallback, error);
				}
			});
			break;
		}
	}
}

@end


#pragma mark - ZPCustomVideoWriterInternal -
@interface ZPCustomVideoWriterInternal : NSObject

@property (nonatomic, strong, readonly) AVAssetWriter *assetWriter;
@property (nonatomic, strong, readonly) AVAssetWriterInput *audioWriterInput;
@property (nonatomic, strong, readonly) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, assign, readonly) NSInteger debugTag;
@property (nonatomic, strong, readonly) NSURL *fileUrl;
@property (nonatomic, assign) BOOL haveStartedSession;

- (void)prepareWithVideoFormat:(CMFormatDescriptionRef)videoFormat audioFormat:(CMFormatDescriptionRef)audioFormat transform:(CGAffineTransform)transform successBlock:(ZPVoidBlock)successBlock faildBlock:(ZPErrorBlock)faildBlock;

@end

@implementation ZPCustomVideoWriterInternal

- (id)init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (void)prepareWithVideoFormat:(CMFormatDescriptionRef)videoFormat audioFormat:(CMFormatDescriptionRef)audioFormat transform:(CGAffineTransform)transform successBlock:(ZPVoidBlock)successBlock faildBlock:(ZPErrorBlock)faildBlock {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
	    NSError *error = nil;
	    _fileUrl = [ZPVideoShared generateRandomTempFile];
	    [[NSFileManager defaultManager] removeItemAtURL:_fileUrl error:NULL];
	    _assetWriter = [[AVAssetWriter alloc] initWithURL:_fileUrl fileType:AVFileTypeMPEG4 error:&error];
	    _assetWriter.shouldOptimizeForNetworkUse = YES;

	    // Create and add inputs
	    if (!error && videoFormat) {
	        [self _setupAssetWriterVideoInput:videoFormat error:&error];
	        _videoWriterInput.transform = transform;
		}

	    if (!error && audioFormat) {
	        [self _setupAssetWriterAudioInput:audioFormat error:&error];
		}

	    if (!error) {
	        BOOL success = [_assetWriter startWriting];
	        if (!success) {
	            error = _assetWriter.error;
			}
		}

	    static NSInteger i = 0;
	    _debugTag = ++i;
	    _haveStartedSession = NO;
	    if (error) {
	        ZPInvokeBlock(faildBlock, error);
		}
	    else {
	        ZPInvokeBlock(successBlock);
		}
	});
}

- (BOOL)_setupAssetWriterAudioInput:(CMFormatDescriptionRef)audioFormatDescription error:(NSError **)errorOut {
	NSDictionary *audioCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
	                                          [NSNumber numberWithInteger:kAudioFormatMPEG4AAC], AVFormatIDKey,
	                                          nil];

	if ([_assetWriter canApplyOutputSettings:audioCompressionSettings forMediaType:AVMediaTypeAudio]) {
		_audioWriterInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioCompressionSettings sourceFormatHint:audioFormatDescription];
		_audioWriterInput.expectsMediaDataInRealTime = YES;

		if ([_assetWriter canAddInput:_audioWriterInput]) {
			[_assetWriter addInput:_audioWriterInput];
		}
		else {
			if (errorOut) {
				*errorOut = [[self class] cannotSetupInputError];
			}
			return NO;
		}
	}
	else {
		if (errorOut) {
			*errorOut = [[self class] cannotSetupInputError];
		}
		return NO;
	}

	return YES;
}

- (BOOL)_setupAssetWriterVideoInput:(CMFormatDescriptionRef)videoFormatDescription error:(NSError **)errorOut {
	float bitsPerPixel;
	CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(videoFormatDescription);
	int numPixels = dimensions.width * dimensions.height;
	int bitsPerSecond;

	// Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
	if (numPixels < (640 * 480)) {
		bitsPerPixel = 4.05; // This bitrate approximately matches the quality produced by AVCaptureSessionPresetMedium or Low.
	}
	else {
		bitsPerPixel = 10.1; // This bitrate approximately matches the quality produced by AVCaptureSessionPresetHigh.
	}

	bitsPerSecond = numPixels * bitsPerPixel;

	NSDictionary *videoCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
	                                          AVVideoCodecH264, AVVideoCodecKey,
	                                          [NSNumber numberWithInteger:dimensions.width], AVVideoWidthKey,
	                                          [NSNumber numberWithInteger:dimensions.height], AVVideoHeightKey,
	                                          [NSDictionary dictionaryWithObjectsAndKeys:
	                                           [NSNumber numberWithInteger:bitsPerSecond], AVVideoAverageBitRateKey,
	                                           [NSNumber numberWithInteger:30], AVVideoMaxKeyFrameIntervalKey,
	                                           nil], AVVideoCompressionPropertiesKey,
	                                          nil];
	if ([_assetWriter canApplyOutputSettings:videoCompressionSettings forMediaType:AVMediaTypeVideo]) {
		_videoWriterInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings sourceFormatHint:videoFormatDescription];
		_videoWriterInput.expectsMediaDataInRealTime = YES;

		if ([_assetWriter canAddInput:_videoWriterInput]) {
			[_assetWriter addInput:_videoWriterInput];
		}
		else {
			if (errorOut) {
				*errorOut = [[self class] cannotSetupInputError];
			}
			return NO;
		}
	}
	else {
		if (errorOut) {
			*errorOut = [[self class] cannotSetupInputError];
		}
		return NO;
	}

	return YES;
}

+ (NSError *)cannotSetupInputError {
	NSString *localizedDescription = NSLocalizedString(@"Recording cannot be started", nil);
	NSString *localizedFailureReason = NSLocalizedString(@"Cannot setup asset writer input.", nil);
	NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
	                           localizedDescription, NSLocalizedDescriptionKey,
	                           localizedFailureReason, NSLocalizedFailureReasonErrorKey,
	                           nil];
	return [NSError errorWithDomain:@"com.zepp.ZPVideo" code:0 userInfo:errorDict];
}

@end

#pragma mark - ZPCustomVideoWriter -
@interface ZPCustomVideoWriter () <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
	AVCaptureConnection *_audioConnection;
	AVCaptureConnection *_videoConnection;
	CMFormatDescriptionRef _audioTrackSourceFormatDescription;
	CMFormatDescriptionRef _videoTrackSourceFormatDescription;

	dispatch_queue_t _writingQueue;
	ZPQueue *_queueWriterInternal;
}
@end

static const NSUInteger MAX_QUEUE_SIZE = 2;
@implementation ZPCustomVideoWriter

- (instancetype)initWithCaptureSession:(AVCaptureSession *)captureSession {
	self = [super initWithCaptureSession:captureSession];
	if (self) {
		dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("com.apple.sample.capturepipeline.video", DISPATCH_QUEUE_SERIAL);
		dispatch_set_target_queue(videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
		dispatch_queue_t audioCaptureQueue = dispatch_queue_create("com.apple.sample.capturepipeline.audio", DISPATCH_QUEUE_SERIAL);

		//Video
		_videoOutput = [[AVCaptureVideoDataOutput alloc] init];
		NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
		[_videoOutput setVideoSettings:videoSettings];
		[_videoOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
		[_videoOutput setAlwaysDiscardsLateVideoFrames:NO];

		if ([_captureSession canAddOutput:_videoOutput]) {
			[_captureSession addOutput:_videoOutput];
		}

		_audioOutput = [[AVCaptureAudioDataOutput alloc] init];
		[_audioOutput setSampleBufferDelegate:self queue:audioCaptureQueue];

		if ([_captureSession canAddOutput:_audioOutput]) {
			[_captureSession addOutput:_audioOutput];
		}

		[self cameraDidRotate];
		_writingQueue = dispatch_queue_create("com.apple.sample.movierecorder.writing", DISPATCH_QUEUE_SERIAL);

		_queueWriterInternal = [[ZPQueue alloc] initWithMaxSize:MAX_QUEUE_SIZE];
	}
	return self;
}

- (void)dealloc {
	ZPLogDebug(@"ZPCustomVideoWriter dealloc");
}

- (void)cameraDidRotate {
	_audioConnection = [_audioOutput connectionWithMediaType:AVMediaTypeAudio];
	_videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
	_videoOrientation = [_videoConnection videoOrientation];
}

- (void)_fullfillWriterQueue {
	if (_audioTrackSourceFormatDescription && _videoTrackSourceFormatDescription) {
		NSInteger size = _queueWriterInternal.size;
		CGAffineTransform transform = [self _transformFromVideoBufferOrientationToOrientation:_videoOrientation withAutoMirroring:NO];
		ZPLogDebug(@"_fullfillWriterQueue queue origin size:%i", (int)size);
		while (size < MAX_QUEUE_SIZE) {
			size++;
			ZPCustomVideoWriterInternal *writerInternal = [[ZPCustomVideoWriterInternal alloc] init];
			[writerInternal prepareWithVideoFormat:_videoTrackSourceFormatDescription audioFormat:_audioTrackSourceFormatDescription transform:transform successBlock: ^{
			    [_queueWriterInternal enqueue:writerInternal];
			    ZPLogDebug(@"did enqueue assetWriter:%i", (int)writerInternal.debugTag);
			} faildBlock: ^(NSError *error) {
			    ZPLogDebug(@"enqueue assetWriter:%i, error:\n%@", (int)writerInternal.debugTag, error);
			}];
		}
	}
}

- (ZPCustomVideoWriterInternal *)_getCurrentWriterInternal {
	ZPCustomVideoWriterInternal *writerInternal = [_queueWriterInternal peek];
	return writerInternal;
}

- (void)_actuallyStart {
	@synchronized(self)
	{
		_status = ZPVideoStatusRecording;
	}

	if (_maxRecordedDuration > 0) {
		dispatch_async(dispatch_get_main_queue(), ^{
		    [self performSelector:@selector(_finishCurrentRecord) withObject:nil afterDelay:_maxRecordedDuration];
		});
	}
}

- (void)startRecordingWithMaxRecordedDuration:(float)maxRecordedDuration loop:(BOOL)loop eachCompletionCallback:(ZPVideoCapturerRecordFinishCallback)eachCompletionCallback allCompletionCallback:(ZPErrorBlock)allCompletionCallback {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusIdle)
			return;
	}

	_loop = loop;
	_needStop = NO;
	_startNewOne = NO;
	_maxRecordedDuration = maxRecordedDuration * 2;
	_eachCompletionCallback = eachCompletionCallback;
	_allCompletionCallback = allCompletionCallback;

	[self _actuallyStart];
}

- (void)stopRecordingWithStartNewOne:(BOOL)startNewOne {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusRecording)
			return;
	}

	_needStop = YES;
	_startNewOne = startNewOne;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_finishCurrentRecord) object:nil];
	[self _finishCurrentRecord];
	_needStop = NO;
}

- (void)cancelRecordingWithCompletion:(ZPVoidBlock)completion {
	[self stopRecordingWithStartNewOne:NO];
	@synchronized(self)
	{
		_status = ZPVideoStatusIdle;
		_needStop = NO;
		_startNewOne = NO;
	}
	// TODO: completion callback
}

- (void)_finishCurrentRecord {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusRecording)
			return;
	}

	ZPCustomVideoWriterInternal *writerInternal = [self _getCurrentWriterInternal];
	[self _finishCurrentRecordWithError:writerInternal.assetWriter.error];
}

- (void)_finishCurrentRecordWithError:(NSError *)error {
	@synchronized(self)
	{
		if (_status != ZPVideoStatusRecording)
			return;
	}

	ZPCustomVideoWriterInternal *writerOld = [_queueWriterInternal dequeue];
	ZPLogDebug(@"writer:%i to remove", (int)writerOld.debugTag);
	ZPCustomVideoWriterInternal *writerNew = [self _getCurrentWriterInternal];

	if (_startNewOne || (!_needStop && _loop)) {
		ZPLogDebug(@"old writer:%i, new writer:%i", (int)writerOld.debugTag, (int)writerNew.debugTag);

		[self _actuallyStart];
	}
	else {
		_status = ZPVideoStatusIdle;
	}
	[self _fullfillWriterQueue];

	[self _finishWriter:writerOld error:error];
}

- (void)_finishWriter:(ZPCustomVideoWriterInternal *)writerOld error:(NSError *)error {
	if (writerOld.assetWriter.status == AVAssetWriterStatusUnknown) {
		ZPLogDebug(@"assetWriter:%i, status:%i is AVAssetWriterStatusUnknown", (int)writerOld.debugTag, (int)writerOld.assetWriter.status);
		return;
	}

	BOOL needStop = _needStop;
	[writerOld.assetWriter finishWritingWithCompletionHandler: ^{
	    ZPLogDebug(@"assetWriter:%i, didFinishRecordingToOutputFileAtURL:%@", (int)writerOld.debugTag, writerOld.assetWriter.outputURL);
	    ZPInvokeBlock(_eachCompletionCallback, YES, writerOld.fileUrl, error);
	    if (needStop) {
	        ZPInvokeBlock(_allCompletionCallback, error);
		}
	}];
	ZPLogDebug(@"assetWriter:%i, finishWritingWithCompletionHandler: called", (int)writerOld.debugTag);
}

#pragma mark - Delegate -

- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType {
	if (sampleBuffer == NULL) {
		ZPLogDebug(@"NULL sample buffer");
		return;
	}

	CFRetain(sampleBuffer);
	dispatch_async(_writingQueue, ^{
	    @autoreleasepool
	    {
	        ZPCustomVideoWriterInternal *writer = [self _getCurrentWriterInternal];
	        if (writer) {
	            if (!writer.haveStartedSession) {
	                if (writer.assetWriter.status == AVAssetWriterStatusUnknown) {
	                    CGAffineTransform transform = [self _transformFromVideoBufferOrientationToOrientation:_videoOrientation withAutoMirroring:NO];
	                    writer.videoWriterInput.transform = transform;
	                    BOOL success = [writer.assetWriter startWriting];
	                    if (!success) {
	                        ZPLogError(@"assetWriter:%i, call startWriting failed:\n%@", (int)writer.debugTag, writer.assetWriter.error);

	                        CFRelease(sampleBuffer);
	                        return;
						}
	                    ZPLogDebug(@"assetWriter:%i, transform to apply:%@", (int)writer.debugTag, NSStringFromCGAffineTransform(transform));
					}

	                if (writer.assetWriter.status == AVAssetWriterStatusWriting) {
	                    ZPLogDebug(@"assetWriter:%i, startSessionAtSourceTime", (int)writer.debugTag);
	                    [writer.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
	                    writer.haveStartedSession = YES;
					}
				}

	            AVAssetWriterInput *input = (mediaType == AVMediaTypeVideo) ? writer.videoWriterInput : writer.audioWriterInput;
	            if (input.readyForMoreMediaData) {
	                BOOL success = [input appendSampleBuffer:sampleBuffer];
	                if (!success) {
	                    NSError *error = writer.assetWriter.error;
	                    [self _finishWriter:writer error:error];

	                    ZPCustomVideoWriterInternal *writerOld = [_queueWriterInternal dequeue];
	                    [self _fullfillWriterQueue];
	                    ZPLogError(@"writer:%i should equal to writerOld:%i", (int)writer.debugTag, (int)writerOld.debugTag);
					}
				}
	            else {
	                ZPLogDebug(@"assetWriter:%i, %@ input not ready for more media data, dropping buffer", (int)writer.debugTag, mediaType);
				}
	            CFRelease(sampleBuffer);
			}
	        else {
	            ZPLogDebug(@"no assetWriter has been ready to write");
	            CFRelease(sampleBuffer);
			}
		}
	});
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);

	if (connection == _videoConnection) {
		if (!_videoTrackSourceFormatDescription) {
			// Don't render the first sample buffer.
			// This gives us one frame interval (33ms at 30fps) for setupVideoPipelineWithInputFormatDescription: to complete.
			// Ideally this would be done asynchronously to ensure frames don't back up on slower devices.
			_videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
			_videoTrackSourceFormatDescription = formatDescription;

			[self _fullfillWriterQueue];
		}
		else {
			@synchronized(self)
			{
				if (_status == ZPVideoStatusRecording) {
					[self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
				}
			}
		}
	}
	else if (connection == _audioConnection) {
		if (!_audioTrackSourceFormatDescription) {
			_audioTrackSourceFormatDescription = formatDescription;

			[self _fullfillWriterQueue];
		}
		else {
			@synchronized(self)
			{
				if (_status == ZPVideoStatusRecording) {
					[self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
				}
			}
		}
	}
}

#pragma mark Utilities

// Auto mirroring: Front camera is mirrored; back camera isn't
- (CGAffineTransform)_transformFromVideoBufferOrientationToOrientation:(AVCaptureVideoOrientation)orientation withAutoMirroring:(BOOL)mirror {
	CGAffineTransform transform = CGAffineTransformIdentity;

	// Calculate offsets from an arbitrary reference orientation (portrait)
	CGFloat orientationAngleOffset = angleOffsetFromPortraitOrientationToOrientation(orientation);
	CGFloat videoOrientationAngleOffset = angleOffsetFromPortraitOrientationToOrientation(_videoOrientation);

	// Find the difference in angle between the desired orientation and the video orientation
	CGFloat angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
	transform = CGAffineTransformMakeRotation(angleOffset);

	if (_videoInput.device.position == AVCaptureDevicePositionFront) {
		if (mirror) {
			transform = CGAffineTransformScale(transform, -1, 1);
		}
		else {
			if (UIInterfaceOrientationIsPortrait((UIInterfaceOrientation)orientation)) {
				transform = CGAffineTransformRotate(transform, M_PI);
			}
		}
	}
	else {
		transform.tx = _videoDimensions.height;
	}

	return transform;
}

static CGFloat angleOffsetFromPortraitOrientationToOrientation(AVCaptureVideoOrientation orientation) {
	CGFloat angle = 0.0;

	switch (orientation) {
		case AVCaptureVideoOrientationPortrait:
			angle = 0.0;
			break;

		case AVCaptureVideoOrientationPortraitUpsideDown:
			angle = M_PI;
			break;

		case AVCaptureVideoOrientationLandscapeRight:
			angle = -M_PI_2;
			break;

		case AVCaptureVideoOrientationLandscapeLeft:
			angle = M_PI_2;
			break;

		default:
			break;
	}

	return angle;
}

@end
