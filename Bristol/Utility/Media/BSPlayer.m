//
//  BSPlayer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSPlayer.h"

@interface BSPlayer () {
	AVPlayerItem *_oldItem;
	id _timeObserver;
}

@end


@implementation BSPlayer

static char *StatusChanged = "StatusContext";
static char *ItemChanged = "CurrentItemContext";
static char *RateChanged = "RateContext";

- (id)init {
	self = [super init];
	
	if (self) {
		[self addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:ItemChanged];
		[self addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:RateChanged];
	}
	
	return self;
}

- (void)dealloc {
	[self endSendingPlayMessages];
	
	[self removeObserver:self forKeyPath:@"currentItem"];
	[self removeObserver:self forKeyPath:@"rate"];
	[self removeOldObservers];
	[self endSendingPlayMessages];
}

- (void)beginSendingPlayMessages {
	if (!self.isSendingPlayMessages) {
		__weak BSPlayer *myWeakSelf = self;
		
		_timeObserver = [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 24) queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
			BSPlayer *mySelf = myWeakSelf;
			id <BSPlayerDelegate> delegate = mySelf.delegate;
			if ([delegate respondsToSelector:@selector(player:didPlay:)]) {
				[delegate player:mySelf didPlay:time];
			}
		}];
	}
}

- (void)endSendingPlayMessages {
	if (_timeObserver != nil) {
		[self removeTimeObserver:_timeObserver];
		_timeObserver = nil;
	}
}

- (void)playReachedEnd:(NSNotification *)notification {
    if (notification.object == self.currentItem) {
        [self seekToTime:kCMTimeZero];
        if (_loopEnabled) {
            [self play];
		}
		if ([self.delegate respondsToSelector:@selector(player:didReachEndForItem:)]) {
			[self.delegate player:self didReachEndForItem:self.currentItem];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == ItemChanged) {
		[self initObserver];
	}
	else if (context == StatusChanged) {
		if ([self.delegate respondsToSelector:@selector(player:itemStatusChanged:)]) {
			[self.delegate player:self itemStatusChanged:self.currentItem];
		}
	} else if (context == RateChanged) {
		if ([self.delegate respondsToSelector:@selector(playerPlayingStateChanged:)]) {
			[self.delegate playerPlayingStateChanged:self];
		}
	}
}

- (void)removeOldObservers {
	if (_oldItem != nil) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_oldItem];
		[_oldItem removeObserver:self forKeyPath:@"status"];
		
		_oldItem = nil;
	}
}

- (void)initObserver {
	[self removeOldObservers];
	
	if (self.currentItem != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReachedEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
		_oldItem = self.currentItem;
		[self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:StatusChanged];
	}
	
	
	id <BSPlayerDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(player:didChangeItem:)]) {
		[delegate player:self didChangeItem:self.currentItem];
	}
}

- (CMTime)playableDuration {
	AVPlayerItem *item = self.currentItem;
	CMTime playableDuration = kCMTimeZero;
	
	if (item.status != AVPlayerItemStatusFailed) {
		for (NSValue *value in item.loadedTimeRanges) {
			CMTimeRange timeRange = [value CMTimeRangeValue];
			
			playableDuration = CMTimeAdd(playableDuration, timeRange.duration);
		}
	}
	
	return playableDuration;
}

- (void)setItemByStringPath:(NSString *)stringPath {
	[self setItemByUrl:[NSURL URLWithString:stringPath]];
}

- (void)setItemByUrl:(NSURL *)url {
	[self setItemByAsset:[AVURLAsset URLAssetWithURL:url options:nil]];
}

- (void)setItemByAsset:(AVAsset *)asset {
	[self setItem:[AVPlayerItem playerItemWithAsset:asset]];
}

- (void)setItem:(AVPlayerItem *)item {
	[self replaceCurrentItemWithPlayerItem:item];
}

- (BOOL)isPlaying {
	return self.rate > 0;
}

- (void)setLoopEnabled:(BOOL)loopEnabled {
	_loopEnabled = loopEnabled;
	
	self.actionAtItemEnd = loopEnabled ? AVPlayerActionAtItemEndNone : AVPlayerActionAtItemEndPause;
}

- (CMTime)itemDuration {
	return self.currentItem.duration;
}

- (BOOL)isSendingPlayMessages {
	return _timeObserver != nil;
}

+ (BSPlayer *)player {
	return [BSPlayer new];
}

@end
