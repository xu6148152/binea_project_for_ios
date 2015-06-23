//
//  ZPVideoPlaybackView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPVideoPlaybackView.h"

@implementation ZPVideoPlaybackView

+ (Class)layerClass {
	return [AVPlayerLayer class];
}

- (void)awakeFromNib {
	self.backgroundColor = [UIColor blackColor];
}

- (AVPlayer *)player {
	return [[self playerLayer] player];
}

- (void)setPlayer:(AVPlayer *)player {
	[[self playerLayer] setVideoGravity:AVLayerVideoGravityResizeAspect];
	[[self playerLayer] setPlayer:player];
}

- (AVPlayerLayer *)playerLayer {
	return (AVPlayerLayer *)[self layer];
}

@end
