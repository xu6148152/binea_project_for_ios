//
//  ZPVideoCapturerPreviewView.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/4/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;
@interface ZPVideoCapturerPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
