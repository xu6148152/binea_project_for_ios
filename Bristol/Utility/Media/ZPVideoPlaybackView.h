//
//  ZPVideoPlaybackView.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZPVideoPlaybackView : UIView

@property (nonatomic, weak) AVPlayer *player;

- (AVPlayerLayer *)playerLayer;

@end
