//
//  BSSoundButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSoundButton.h"
#import "ZPProgressView.h"

#import "SoundManager.h"
#import "PureLayout.h"

@interface BSSoundButton()
{
	NSString *_imageNameStopped, *_imageNamePlaying;
	NSTimer *_tmr;
	BSSongDataModel *_song;
	Sound *_sound;
}
@property(nonatomic, strong) ZPProgressView *progressView;

@end

@implementation BSSoundButton

- (void)_setDefaults {
	[self addTarget:self action:@selector(_tap) forControlEvents:UIControlEventTouchUpInside];
	_imageNameStopped = @"capture_previewmusic";
	_imageNamePlaying = @"capture_stoppreviewmusic";
}

- (id)init {
	self = [super init];
	if (self) {
		[self _setDefaults];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self _setDefaults];
}

- (ZPProgressView *)progressView {
	if (!_progressView) {
		UIImage *image = [UIImage imageNamed:_imageNameStopped];
		float insetH = (self.width - image.size.width) / 2;
		float insetV = (self.height - image.size.height) / 2;
		
		_progressView = [ZPProgressView newAutoLayoutView];
		_progressView.backgroundTintColor = [UIColor clearColor];
		_progressView.progressTintColor = [UIColor blackColor];
		_progressView.userInteractionEnabled = NO;
		[self addSubview:_progressView];
		[_progressView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(insetV, insetH, insetV, insetH)];
	}
	return _progressView;
}

- (void)_tap {
	switch (_song.status) {
  		case BSSongPlayingStatusStop:
			_song.status = BSSongPlayingStatusPlay;
			break;
		case BSSongPlayingStatusPause:
			_song.status = BSSongPlayingStatusPlay;
			
			break;
		case BSSongPlayingStatusPlay:
			_song.status = BSSongPlayingStatusPause;
			
			break;
	}
	[self _updateUI];
}

- (void)_setAsStopped {
	_song.status = BSSongPlayingStatusStop;
	_sound = nil;
	[self _updateUI];
}

- (void)_tick {
	float progress = 0;
	if (_sound.duration != 0) {
		progress = _sound.currentTime / _sound.duration;
	}
	_progressView.progress = progress;
}

- (void)_setIsUpdatingProgress:(BOOL)updating {
	if (updating) {
		_tmr = [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(_tick) userInfo:nil repeats:YES];
	} else {
		[_tmr invalidate];
		_tmr = nil;
	}
}

- (void)_updateUI {
	NSString *imageName;
	switch (_song.status) {
		case BSSongPlayingStatusStop:
			imageName = _imageNameStopped;
			_progressView.hidden = YES;
			break;
		case BSSongPlayingStatusPause:
			imageName = _imageNamePlaying;
			self.progressView.hidden = NO;
			
			[_sound pause];
			[self _setIsUpdatingProgress:NO];
			break;
		case BSSongPlayingStatusPlay:
			imageName = _imageNamePlaying;
			self.progressView.hidden = NO;
			
			[[SoundManager sharedManager] stopAllSounds:NO];
			if (!_sound || ![_sound.URL isEqual:_song.url]) {
				__weak typeof(self) weakSelf = self;
				_sound = [Sound soundWithContentsOfURL:_song.url];
				_sound.completionHandler = ^ (BOOL didFinish) {
					[weakSelf _setAsStopped];
				};
			}
			[[SoundManager sharedManager] playSound:_sound looping:NO fadeIn:YES];
			[self _setIsUpdatingProgress:YES];
			
			break;
	}
	[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)configWithSong:(BSSongDataModel *)song {
	if (_song != song) {
		_song = song;
		
		[self _updateUI];
	}
}

@end
