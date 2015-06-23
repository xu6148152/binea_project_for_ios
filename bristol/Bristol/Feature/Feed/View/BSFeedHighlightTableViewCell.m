//
//  BSFeedHighlightTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedHighlightTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSActivityIndicatorButton.h"
#import "BSLoadingImageView.h"

#import "BSLogHighlightHttpRequest.h"

#import "BSCoreImageManager.h"
#import "BSDataManager.h"
#import "BSBackgroundTimer.h"

#import "BSPlayer.h"
#import "ZPVideoPlaybackView.h"
#import "BSCIMultiplyBlendFrameFilter.h"

#import "PureLayout.h"
#import "NAKPlaybackIndicatorView.h"

@interface BSFeedHighlightTableViewCell ()<BSPlayerDelegate>
{
	BSHighlightMO *_highlight;
	UITapGestureRecognizer *_singleTapGesture;
	UITapGestureRecognizer *_doubleTapGesture;
    NSArray *_originConstraints;
    UIView *_originSuperView;
    CGRect _originFrame;
	BOOL _isPlayingWhenResignActive;
	BOOL _isMute, _isAutoPlayVideo, _isLoopingVideo, _isTapToFullScreen;
}
@property (nonatomic, strong) BSPlayer *moviePlayer;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *fullScreenView;

//@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *btnPlaybackIndicator;

@property (weak, nonatomic) IBOutlet UIView *videoHostView;
@property (weak, nonatomic) IBOutlet UIImageView *videoCoverImageView;
@property (weak, nonatomic) IBOutlet ZPVideoPlaybackView *videoPlaybackView;
@property (weak, nonatomic) IBOutlet BSLoadingImageView *progressView;

@end

#define kToggleVideoMuteNotification @"kToggleVideoMuteNotification"
#define kIsVideoMute @"kIsVideoMute"

@implementation BSFeedHighlightTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_videoViewSingleTapped)];
	_singleTapGesture.numberOfTapsRequired = 1;
	[_videoHostView addGestureRecognizer:_singleTapGesture];
	
	_doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_videoViewDoubleTapped)];
	_doubleTapGesture.numberOfTapsRequired = 2;
	[_videoHostView addGestureRecognizer:_doubleTapGesture];
	[_singleTapGesture requireGestureRecognizerToFail:_doubleTapGesture];

	_moviePlayer = [BSPlayer player];
	_moviePlayer.delegate = self;
	_moviePlayer.loopEnabled = YES;
	_videoPlaybackView.player = _moviePlayer;
	_videoPlaybackView.userInteractionEnabled = NO;
//	_moviePlayer.CIImageRenderer = _videoPlaybackView;
	
//	UITapGestureRecognizer *tapPlaybackIndicator = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_btnPlaybackIndicatorTapped)];
//	[_btnPlaybackIndicator addGestureRecognizer:tapPlaybackIndicator];
//	_btnPlaybackIndicator.backgroundColor = [UIColor clearColor];
//	_btnPlaybackIndicator.tintColor = [UIColor whiteColor];
//	_btnPlaybackIndicator.state = NAKPlaybackIndicatorViewStatePaused;
	
    [self _loadVideoConfiguration];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateVideoMuteState) name:kToggleVideoMuteNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadVideoConfiguration) name:kFeedConfigurationDidChangedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)prepareForReuse {
	[super prepareForReuse];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITableView *)tableView {
	if (!_tableView) {
		UIView *view = [self superview];
		while (![view isKindOfClass:[UITableView class]]) {
			view = [view superview];
		}
		_tableView = (UITableView *)view;
	}
	return _tableView;
}

- (UIView *)fullScreenView {
    if (!_fullScreenView) {
        _fullScreenView = [UIView newAutoLayoutView];
        _fullScreenView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_videoViewSingleTapped)];
        [_fullScreenView addGestureRecognizer:tap];
    }
    return _fullScreenView;
}

- (void)_applicationWillResignActive {
	_isPlayingWhenResignActive = [_moviePlayer isPlaying];
	[_moviePlayer pause];
}

- (void)_applicationDidBecomeActive {
	if (_isPlayingWhenResignActive) {
		[_moviePlayer play];
	}
}

- (void)_loadVideoConfiguration {
    _isMute = ![UserDefaults boolForKey:kFeedAutoPlayAudio];
    _isAutoPlayVideo = [UserDefaults boolForKey:kFeedAutoPlayVideo];
    _isLoopingVideo = _moviePlayer.loopEnabled = [UserDefaults boolForKey:kFeedLoopingVideo];
    _isTapToFullScreen = [UserDefaults boolForKey:kFeedTapToFullscreen];
}

- (void)_videoViewSingleTapped {
    if (NO/*_isTapToFullScreen*/) {
        UIWindow *window = self.window;
        window.userInteractionEnabled = NO;
        
        BOOL isAlreadyInFullScreen = _videoPlaybackView.superview == window;
        if (isAlreadyInFullScreen) {
            [UIView animateWithDuration:kDefaultAnimateDuration animations:^{
                self.fullScreenView.alpha = 0;
                _videoPlaybackView.frame = _originFrame;
            } completion:^(BOOL finished) {
                [self.fullScreenView removeFromSuperview];
                self.fullScreenView = nil;
                
                [_originSuperView insertSubview:_videoPlaybackView atIndex:0];
                [_videoPlaybackView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                [_videoPlaybackView layoutIfNeeded];
                window.userInteractionEnabled = YES;
            }];
            [self.fullScreenView removeConstraints:self.fullScreenView.constraints];
            [self checkIfCanPlayVideo];
        } else {
            self.fullScreenView.alpha = 0;
            [window addSubview:self.fullScreenView];
            [self.fullScreenView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            
            _originConstraints = _videoPlaybackView.constraints;
            _originSuperView = _videoPlaybackView.superview;
            [window addSubview:_videoPlaybackView];
            CGRect rect = self.frame;
            rect.size.height = _videoPlaybackView.height;
            _originFrame = [self.tableView convertRect:rect toView:window];
            [_videoPlaybackView removeConstraints:_originConstraints];
            [window layoutIfNeeded];
            _videoPlaybackView.frame = _originFrame;
            
            [UIView animateWithDuration:kDefaultAnimateDuration animations:^{
                self.fullScreenView.alpha = 1;
                _videoPlaybackView.top = (window.height - _videoPlaybackView.height) / 2;
            } completion:^(BOOL finished) {
                _videoPlaybackView.frame = _originFrame;
                _videoPlaybackView.top = (window.height - _videoPlaybackView.height) / 2;
                [self playVideo];
                window.userInteractionEnabled = YES;
            }];
        }
    } else {
		[self _btnPlaybackIndicatorTapped];
		/*
        if (_moviePlayer.isPlaying) {
            [self pauseVideo];
        } else {
            [self playVideo];
        }*/
    }
}

- (void)_videoViewDoubleTapped {
	[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightDoubleTappedNotification object:_doubleTapGesture];
}

- (void)_updateVideoMuteState {
	_moviePlayer.muted = _isMute;
//	if (_isMute || !_moviePlayer.isPlaying) {
//		_btnPlaybackIndicator.state = NAKPlaybackIndicatorViewStatePaused;
//	} else {
//		_btnPlaybackIndicator.state = NAKPlaybackIndicatorViewStatePlaying;
//	}
}

- (void)_btnPlaybackIndicatorTapped {
	_isMute = !_isMute;
	[UserDefaults setBool:!_isMute forKey:kFeedAutoPlayAudio];
	[UserDefaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:kToggleVideoMuteNotification object:self];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	if (_highlight != highlight) {
		_highlight = highlight;
		
		// video cover image
		NSURL *urlCover = [NSURL URLWithString:_highlight.cover_url];
		ZPVoidBlock imageDidDownloadBlock = ^ {
			_videoCoverImageView.hidden = NO;
			[_videoCoverImageView sd_setImageWithURL:urlCover placeholderImage:[BSUIGlobal placeholderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			}];
		};
		if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:urlCover]) {
			ZPLogDebug(@"video thumbnail exists for Highlight:%@", _highlight.identifier);
			imageDidDownloadBlock();
		}
		else {
			_videoCoverImageView.hidden = YES;
			ZPLogDebug(@"video thumbnail doesn't exist for Highlight:%@", _highlight.identifier);
			[[SDWebImageManager sharedManager] downloadImageWithURL:urlCover options:SDWebImageRetryFailed | SDWebImageContinueInBackground progress: ^(NSInteger receivedSize, NSInteger expectedSize) {
			    if (_highlight == highlight) {
//                    ZPLogDebug(@"image progress:%.1f", (float)receivedSize/expectedSize);
				}
			} completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
			    if (_highlight == highlight) {
			        if (image && !error) {
						imageDidDownloadBlock();
					}
			        else {
					}
				}
			}];
		}

		// video
		NSURL *urlVideoLocal = [NSURL fileURLWithPath:[[BSDataManager sharedInstance] getVideoFullPathForHighlight:_highlight]];
	tryagain:
		if ([[BSDataManager sharedInstance] isVideoDownloadedForHighlight:_highlight]) {
			_videoPlaybackView.hidden = NO;
			
			AVURLAsset *asset = [AVURLAsset URLAssetWithURL:urlVideoLocal options:nil];
			[_moviePlayer setItemByAsset:asset];
			float duration = CMTimeGetSeconds(asset.duration);
			if (duration == 0 || isnan(duration)) {
				[[NSFileManager defaultManager] removeItemAtURL:urlVideoLocal error:NULL];
				goto tryagain;
			}
			
			_singleTapGesture.enabled = YES;
		}
		else {
			_videoPlaybackView.hidden = YES;
			[self _setProgressViewAnimated:YES];

			AVURLAsset *asset = [[BSDataManager sharedInstance] streamVideoForHighlight:_highlight progress: ^(float progress) {
                if (_highlight == highlight) {
//					ZPLogDebug(@"progress:%.2f for Highlight:%@", progress, _highlight.identifier);
                }
			} success: ^() {
			    if (_highlight == highlight) {
					_singleTapGesture.enabled = YES;
					[self checkIfCanPlayVideo];
				}
			} faild: ^(NSError *error) {
			}];
			[_moviePlayer setItemByAsset:asset];
			
			_singleTapGesture.enabled = NO;
		}
	}
}

- (void)checkIfCanPlayVideo {
	if (_isAutoPlayVideo && [self isVisibleToPlayVideo]) {
		[self playVideo];
    } else {
        [self pauseVideo];
    }
}

- (BOOL)isVisibleToPlayVideo {
	if (self.window && !self.hidden) {
		CGRect rect = [_videoPlaybackView convertRect:_videoPlaybackView.frame toView:self.tableView];
		rect = CGRectOffset(rect, 0, -self.tableView.contentOffset.y);
		CGRect rectValid = self.tableView.frame;
		static const float RANGE = 60;
		rectValid = CGRectMake(0, rectValid.size.height / 2 - RANGE, rectValid.size.width, RANGE * 2);

		BOOL intersect = CGRectIntersectsRect(rectValid, rect);
		return intersect;
	}
	return NO;
}

- (BOOL)playVideo {
	if (!_moviePlayer.isPlaying && _moviePlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
		_videoCoverImageView.hidden = YES;
		_videoPlaybackView.hidden = NO;

		[_moviePlayer play];
//		ZPLogDebug(@"play video for Highlight:%@", _highlight.identifier);
		[self _updateVideoMuteState];
		
		return YES;
	} else {
		return NO;
	}
}

- (void)pauseVideo {
	if (_moviePlayer.isPlaying) {
		[_moviePlayer pause];
//		ZPLogDebug(@"pause video for Highlight:%@", _highlight.identifier);
		[self _updateVideoMuteState];
	}
}

#pragma mark - BSPlayerDelegate
- (void)player:(BSPlayer *)player didReachEndForItem:(AVPlayerItem *)item {
	static NSMutableDictionary *dicLogged;
	if (!dicLogged) {
		dicLogged = [NSMutableDictionary dictionary];
	}
	
	NSNumber *identifierCopiedToAvoidDelete = [_highlight.identifier copy];
	if (_highlight && identifierCopiedToAvoidDelete && !dicLogged[identifierCopiedToAvoidDelete]) {
		BSLogHighlightHttpRequest *request = [BSLogHighlightHttpRequest requestWithLogHighlightDataModels:@[[BSLogHighlightDataModel dataModelWithHighlightId:_highlight.identifierValue playedTimes:1]]];
		[request postRequest];
		
		dicLogged[identifierCopiedToAvoidDelete] = [NSNull null];
	}
}

- (void)_setProgressViewAnimated:(BOOL)animated {
	_progressView.hidden = !animated;
	if (animated) {
		[_progressView startLoadingAnimation];
	} else {
		[_progressView stopLoadingAnimation];
	}
}

- (void)player:(BSPlayer *)player itemReadyToPlay:(AVPlayerItem *)item{
	switch (item.status) {
		case AVPlayerItemStatusUnknown:
			[self _setProgressViewAnimated:YES];
			ZPLogDebug(@"AVPlayerItem status Unknow: %@", item);
			break;
		case AVPlayerItemStatusFailed:
			[self _setProgressViewAnimated:YES];
			ZPLogDebug(@"AVPlayerItem status Failed: %@", item);
			break;
		case AVPlayerItemStatusReadyToPlay:
			[self _setProgressViewAnimated:NO];
			ZPLogDebug(@"AVPlayerItem status ReadyToPlay: %@", item);
			break;
	}
	[self checkIfCanPlayVideo];
}

- (void)player:(BSPlayer *)player didChangeItem:(AVPlayerItem *)item {
	ZPLogDebug(@"player didChangeItem:%@", item);
}

@end
