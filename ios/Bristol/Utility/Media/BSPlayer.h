//
//  BSPlayer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class BSPlayer;

@protocol BSPlayerDelegate <NSObject>

@optional
- (void)player:(BSPlayer *)player didPlay:(CMTime)currentTime;
- (void)player:(BSPlayer *)player didChangeItem:(AVPlayerItem *)item;
- (void)player:(BSPlayer *)player didReachEndForItem:(AVPlayerItem *)item;
- (void)player:(BSPlayer *)player itemStatusChanged:(AVPlayerItem *)item;
- (void)playerPlayingStateChanged:(BSPlayer *)player;

@end

@interface BSPlayer : AVPlayer

@property (weak, nonatomic) id <BSPlayerDelegate> delegate;
@property (assign, nonatomic) BOOL loopEnabled;
@property (readonly, nonatomic) BOOL isPlaying;
@property (readonly, nonatomic) CMTime itemDuration;

+ (BSPlayer *)player;

- (void)beginSendingPlayMessages;
- (void)endSendingPlayMessages;

- (void)setItemByStringPath:(NSString *)stringPath;
- (void)setItemByUrl:(NSURL *)url;
- (void)setItemByAsset:(AVAsset *)asset;
- (void)setItem:(AVPlayerItem *)item;

@end
