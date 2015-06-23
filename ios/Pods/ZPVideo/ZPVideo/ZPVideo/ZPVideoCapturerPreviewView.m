//
//  ZPVideoCapturerPreviewView.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/4/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPVideoCapturerPreviewView.h"
#import <AVFoundation/AVFoundation.h>

// Set Logging Component
#undef ZPLogComponent
#define ZPLogComponent lcl_cVideo

@implementation ZPVideoCapturerPreviewView

+ (Class)layerClass {
	return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session {
	return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session {
	[(AVCaptureVideoPreviewLayer *)[self layer] setSession : session];

	self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
