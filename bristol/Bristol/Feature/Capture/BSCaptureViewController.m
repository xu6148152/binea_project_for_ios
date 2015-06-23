//
//  BSCaptureViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCaptureViewController.h"
#import "BSCaptureChooseTeamViewController.h"
#import "BSCaptureChooseLocationViewController.h"
#import "BSCaptureChooseSportViewController.h"
#import "BSMainViewController.h"
#import "BSAuthorizationViewController.h"
#import "BSCapturePostViewController.h"
#import "BSCaptureChooseSongViewController.h"
#import "BSCapturePopupViewController.h"

#import "BSHighlightEffectCollectionViewCell.h"
#import "BSEffectBaseCompositionLayer.h"
#import "BSBaseButton.h"
#import "BSVideoTrimmerView.h"
#import "AVFoundationEditor.h"

#import "BSCoreImageManager.h"
#import "BSHighlightEffectManager.h"
#import "BSBaseVideoCompositor.h"

#import "BSHighlightPostHttpRequest.h"
#import "BSHighlightPostUploadVideoHttpRequest.h"
#import "BSHighlightGetShareUrlHttpRequest.h"
#import "BSBlockTimer.h"
#import "ZPVideo.h"
#import "ZPVideoPlaybackView.h"
#import "AVAssetExportSession+Progress.h"

#import "BSPlayer.h"
#import "ZPVideoPlaybackView.h"
#import "BSCIMultiplyBlendFrameFilter.h"

#import "SZTextView.h"

#import "CTAssetsPickerController.h"
#import "CTAssetsViewController.h"

#import <VideoKit/VideoKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSInteger, BSHighlightStep) {
    BSHighlightStepCapture = 0,
    BSHighlightStepEdit,
    BSHighlightStepShare,
};

#define kMinVideoDuration (5.1)
#define kCaptureDidFinishNotification @"kCaptureDidFinishNotification"

@interface BSCaptureViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSVideoTrimmerViewDelegate, BSPlayerDelegate, CTAssetsPickerControllerDelegate>
{
    ZPVideoCapturer *_videoCapturer;
	THAdvancedCompositionBuilder *_compositionBuilder;
	THTimeline *_timeline;
	AVAssetExportSession *_exportSession;
	AVSynchronizedLayer *_titleLayer;
	AVPlayerItem *_playerItemNormal, *_playerItemWithEffect;
	
    BSHighlightBaseEffectModel *_effectModelSelected;
    BSHighlightStep _currentStep;
	BSVideoTrimmerView *_videoTrimmerView;
	BSCapturePostViewController *_postViewController;
	BSCaptureChooseLocationViewController *_chooseLocationViewController;
	NSArray *_highlightsDetected;
	NSMutableArray *_captureUrlSegments;
    NSURL *_videoUrl, *_videoUrlProcessed;
    float _videoDuration;
    BOOL _isCapturing;
	BOOL _isNOVideoEffect;
	BOOL _needToRegeratePlayItem;
	BOOL _needToGoToStep2;
	
	BSAuthorizationViewController *_authorizationViewController;
	ALAsset *_currentSelectedAsset;
}
// private properties
@property (assign, nonatomic) BOOL canPostAfterExport;
@property (strong, nonatomic) id placeSelected;
@property (strong, nonatomic) BSSongDataModel *songSelected;
@property (strong, nonatomic) BSTeamMO *teamSelected;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) BSBlockTimer *blockTimer;
@property (strong, nonatomic) BSPlayer *moviePlayer;
@property (strong, nonatomic) VkHighlightDetector *highlightDetector;

// video view
@property (weak, nonatomic) IBOutlet UIView *videoRecordPlayView;
@property (weak, nonatomic) IBOutlet ZPVideoPlaybackView *videoPlaybackView;
@property (weak, nonatomic) IBOutlet BSBaseButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnRotateCamera;
@property (weak, nonatomic) IBOutlet BSBaseButton *btnLocation;
@property (weak, nonatomic) IBOutlet BSBaseButton *btnAddATeam;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseSong;
@property (weak, nonatomic) IBOutlet UIView *videoDurationPromptView;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationCancelStep1;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationCancelStep2;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationCancelStep3;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationNextStep1;
@property (weak, nonatomic) IBOutlet UIView *navigationViewStep1;
@property (weak, nonatomic) IBOutlet UIView *navigationViewStep2;
@property (weak, nonatomic) IBOutlet UIView *navigationViewStep3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewStep1LeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewStep2LeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewStep3LeadingConstraint;

// capture view
@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *captureBlendView;
@property (weak, nonatomic) IBOutlet UIView *captureControlView;
@property (weak, nonatomic) IBOutlet UIView *captureWaitingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *captureWaitingActivity;
@property (weak, nonatomic) IBOutlet UILabel *lblCaptureWaiting;
@property (weak, nonatomic) IBOutlet UILabel *lblCapturedDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnImportVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;

// edit view
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIView *videoTrimmerHostView;
@property (weak, nonatomic) IBOutlet UICollectionView *editEffectCollectionView;

// share view
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet SZTextView *txtDescription;

@end

@implementation BSCaptureViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Capture" bundle:nil] instantiateViewControllerWithIdentifier:@"BSCaptureViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Capture" bundle:nil] instantiateViewControllerWithIdentifier:@"BSCaptureViewControllerNav"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	
	_txtDescription.text = @"";
	_txtDescription.placeholder = ZPLocalizedString(@"Add caption");
	_btnAddATeam.titleLabel.numberOfLines = 2;
	_btnLocation.titleLabel.numberOfLines = 2;
	_btnNavigationCancelStep2.imageView.contentMode = _btnNavigationCancelStep3.imageView.contentMode = UIViewContentModeCenter;
	
    _videoCapturer = [[ZPVideoCapturer alloc] init];
	_videoCapturer.enableAudio = YES;
    _videoCapturer.sessionPreset = AVCaptureSessionPreset640x480;
    _videoCapturer.frameRate = 239;
	_videoCapturer.disableFocusAndExposeWhileRecording = NO;
    _videoCapturer.previewView.translatesAutoresizingMaskIntoConstraints = NO;
    [_videoRecordPlayView addSubview:_videoCapturer.previewView];
    [_videoCapturer.previewView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
	
//	_blendFilter = [BSCIMultiplyBlendFrameFilter filter];
//	_videoPlaybackView.filterGroup = @[_blendFilter];
	
	_moviePlayer = [BSPlayer player];
	_moviePlayer.delegate = self;
	_moviePlayer.loopEnabled = YES;
	_videoPlaybackView.player = _moviePlayer;
//	_moviePlayer.CIImageRenderer = _videoPlaybackView;
	[_moviePlayer beginSendingPlayMessages];
	
	[self _setupComposition];
	
    [self _goToCaptureViewAnimated:NO];
    
    [_editEffectCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    if ([BSUtility getPopUpFirstActionDate:kFirstCaptureDate] == nil) {
        [BSUtility savePopUpFirstActionDate:[NSDate date] withKey:kFirstCaptureDate];
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_checkAuthorizationStatus) name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_captureDidFinishNotification) name:kCaptureDidFinishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	[self _testWithDefaultVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	[self _pauseVideo];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_moviePlayer endSendingPlayMessages];
	[BSHighlightEffectManager clearSharedInstance];
}

- (void)_removeAuthorizationView {
	[_authorizationViewController.view removeFromSuperview];
	_authorizationViewController = nil;
}

- (void)_checkAuthorizationStatus {
	if (_currentStep == BSHighlightStepCapture) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		switch (status) {
			case AVAuthorizationStatusNotDetermined:
				
				break;
			case AVAuthorizationStatusDenied:
			case AVAuthorizationStatusRestricted:
			{
				[self _removeAuthorizationView];
				_authorizationViewController = [BSAuthorizationViewController instanceFromDefaultNibWithType:BSAuthorizationTypeCamera];
				[_videoRecordPlayView addSubview:_authorizationViewController.view];
				[_authorizationViewController.view autoCenterInSuperview];
				
				_btnCapture.enabled = _btnRotateCamera.enabled = _btnNavigationNextStep1.enabled = NO;
				break;
			}
			case AVAuthorizationStatusAuthorized:
				[self _removeAuthorizationView];
				_btnCapture.enabled = _btnRotateCamera.enabled = YES;
				break;
		}
	}
}

- (void)_testWithDefaultVideo {
	if (!_videoUrl) {
		_videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"03_Car" ofType:@"mp4"]];
		[self _goToHighlightDetectView];
		[self _detectHighlight];
	}
}

- (BSBlockTimer *)blockTimer {
    if (!_blockTimer) {
        _blockTimer = [[BSBlockTimer alloc] init];
    }
    return _blockTimer;
}

- (VkHighlightDetector *)highlightDetector {
	if (!_highlightDetector) {
		_highlightDetector = VkHighlightDetector.new;
	}
	return _highlightDetector;
}

- (void)setPlaceSelected:(id)placeSelected {
	if (_placeSelected != placeSelected) {
		[self _cancelPreviousExportVideo];
	}
	_placeSelected = placeSelected;
	
	NSString *location = nil;
	if ([_placeSelected isKindOfClass:[BSHighlightPlaceDataModel class]]) {
		location = ((BSHighlightPlaceDataModel *)_placeSelected).nameLocalized;
	} else if ([_placeSelected isKindOfClass:[BSEventMO class]]) {
		location = ((BSEventMO *)_placeSelected).name;
	} else if ([_placeSelected isKindOfClass:[NSString class]]) {
		location = _placeSelected;
	} else {
		location = nil;
	}
	
	[self _setLocationWithTitle:location];
	_effectModelSelected.compositionLayer.location = location ?: @"LOCATION";
}

- (void)setTeamSelected:(BSTeamMO *)teamSelected {
	if (_teamSelected != teamSelected) {
		[self _cancelPreviousExportVideo];
	}
	_teamSelected = teamSelected;
	
	UIImage *imageTeamLogo = nil;
	if (teamSelected) {
		[_btnAddATeam setTitle:teamSelected.name forState:UIControlStateNormal];
		[_btnAddATeam setImage:nil forState:UIControlStateNormal];
		
		NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_teamSelected.avatar_url]];
		imageTeamLogo = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
	} else {
		[_btnAddATeam setTitle:nil forState:UIControlStateNormal];
		[_btnAddATeam setImage:_btnAddATeam.imageDesignedOfNormal forState:UIControlStateNormal];
	}
	
	_effectModelSelected.compositionLayer.team = _teamSelected.name ?: @"TEAMNAME";
	_effectModelSelected.compositionLayer.imageTeamLogo = imageTeamLogo;
}

- (void)setSongSelected:(BSSongDataModel *)songSelected {
	_songSelected = songSelected;
    _btnChooseSong.backgroundColor = songSelected ? [UIColor colorWithRed255:193 green255:220 blue255:0 alphaFloat:.9] : [UIColor colorWithWhite:1 alpha:.8];
	
	if (_isNOVideoEffect) {
		[_effectModelSelected updateAudioWithUrl:songSelected.url completion:nil];
		_timeline.musicItems = _effectModelSelected.musicItems;
		_needToRegeratePlayItem = YES;
	}
}

#pragma mark - post
- (BOOL)_isVideoExported {
    if (![[NSFileManager defaultManager] fileExistsAtPath:_videoUrlProcessed.correctPath]) {
        return NO;
    }
    return YES;
}

- (void)_cancelPreviousExportVideo {
	[_exportSession cancelExport];
	_exportSession = nil;
	if (_videoUrlProcessed) {
		[[NSFileManager defaultManager] removeItemAtURL:_videoUrlProcessed error:NULL];
		_videoUrlProcessed = nil;
	}
}

- (void)_exportVideoDidCompleted {
	if (_exportSession.status == AVAssetExportSessionStatusCompleted) {
		dispatch_main_sync_safe(^ {
			_videoUrlProcessed = _exportSession.outputURL;
			if (self.canPostAfterExport) {
				[self _post];
			}
		});
	} else if (_exportSession.status == AVAssetExportSessionStatusFailed) {
		[BSUIGlobal showAlertMessage:_exportSession.error.localizedFailureReason cancelTitle:ZPLocalizedString(@"Go back") cancelHandler:^{
			[self _goToEditView];
		} actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
			[self _exportVideo];
		}];
		ZPLogDebug(@"Export video error: %@", _exportSession.error);
	} else {
		[self _goToEditView];
	}
}

- (void)_exportVideo {
    THAdvancedComposition *composition = [self _buildComposition];
	_exportSession = [composition makeExportableWithPresetName:AVAssetExportPreset640x480];
	_exportSession.outputURL = [self _getVideoProcessedFileFullPath];
	_exportSession.outputFileType = AVFileTypeMPEG4;
	_exportSession.shouldOptimizeForNetworkUse = YES;
	
	__weak typeof(self) weakSelf = self;
	[_exportSession exportAsynchronouslyWithProgress:^(float progress) {
		ZPLogDebug(@"Export video progress:%.2f", progress);
		weakSelf.hud.progress = progress;
	} completionHandler:^{
		ZPLogDebug(@"Export video complete");
		[weakSelf _exportVideoDidCompleted];
	}];
}

- (void)_showExportingHud {
	_hud = [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Exporting")];
	if (_hud.mode != MBProgressHUDModeAnnularDeterminate) {
		_hud.mode = MBProgressHUDModeAnnularDeterminate;
	}
}

- (void)_hideHud {
	[_hud hide:YES];
}

- (void)_post {
	if (![self _isVideoExported]) {
		[self _showExportingHud];
	} else {
		[self _hideHud];
		
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(kInvalidCoordinate, kInvalidCoordinate);
		NSString *locationName = nil;
		BSEventMO *event = nil;
		if ([_placeSelected isKindOfClass:[BSHighlightPlaceDataModel class]]) {
			BSHighlightPlaceDataModel *_place = (BSHighlightPlaceDataModel *)_placeSelected;
			coordinate.latitude = _place.latitude;
			coordinate.longitude = _place.longitude;
			locationName = _place.nameLocalized;
		} else if ([_placeSelected isKindOfClass:[BSEventMO class]]) {
			event = (BSEventMO *)_placeSelected;
		} else if ([_placeSelected isKindOfClass:[NSString class]]) {
			locationName = _placeSelected;
		}
		
		NSMutableArray *types = [NSMutableArray array];
		if (_postViewController.btnShareWithFB.selected) {
			[types addObject:kHighlightShareTypeFacebook];
		}
		if (_postViewController.btnShareWithTwitter.selected) {
			[types addObject:kHighlightShareTypeTwitter];
		}
		if (_postViewController.btnShareWithIG.selected) {
			[types addObject:kHighlightShareTypeInstagram];
		}
		NSString *shareTypes = @"";
		for (NSString *type in types) {
			if (shareTypes.length > 0) {
				shareTypes = [NSString stringWithFormat:@"%@,%@", shareTypes, type];
			} else {
				shareTypes = type;
			}
		}
		
		[[BSCoreImageManager sharedManager] generateImageForVideoUrl:_videoUrlProcessed size:kRenderedVideoSize withFilter:BSCoreImageFilterNone atTimes:@[@0] completion:^(NSArray *images) {
			NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [_videoUrlProcessed lastPathComponent]];
			NSString *imagePath = [[[BSDataManager sharedInstance] getVideoFullPath] stringByAppendingPathComponent:imageName];
			UIImage *image = [images firstObject];
			BOOL success = [UIImageJPEGRepresentation(image, .9) writeToFile:imagePath atomically:YES];
			if (!success) {
				ZPLogError(@"write thumbnail error:%@", imagePath);
			}
			
			[[BSDataManager sharedInstance] postHighlightWithMessage:_txtDescription.text coordinate:coordinate locationName:locationName sportType:(NSInteger)_postViewController.sportSelected.identifierValue localCoverPath:imagePath localVideoPath:_videoUrlProcessed.correctPath shootAt:[NSDate date] shareTypes:shareTypes event:event team:_teamSelected];
			
			[self _exitThisViewController];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightDidEnqueueToPostNotification object:nil];
		}];
	}
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
	if ([segue.identifier isEqualToString:@"ShowSongList"]) {
		BSCaptureChooseSongViewController *vc = segue.destinationViewController;
		vc.selectedObject = _songSelected;
		vc.selectedObjectDidChangedBlock = ^ (NSObject *object) {
			weakSelf.songSelected = (BSSongDataModel *)object;
		};
	} else if ([segue.identifier isEqualToString:@"ShowTeamList"]) {
        BSCaptureChooseTeamViewController *vc = segue.destinationViewController;
        vc.selectedObject = _teamSelected;
        vc.selectedObjectDidChangedBlock = ^ (NSObject *object) {
            weakSelf.teamSelected = (BSTeamMO *)object;
        };
    }
    
    [self _hideKeyboard];
}

- (void)_exitThisViewController {
	[_videoCapturer stopSession];
	[self dismissViewControllerAnimated:YES completion:NULL];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	
	// remove original recorded or imported video
	[[NSFileManager defaultManager] removeItemAtURL:_videoUrl error:NULL];
}

- (void)_hideKeyboard {
    [_txtDescription resignFirstResponder];
}

- (void)_layoutViews:(NSArray *)aryViews {
    for (UIView *view in aryViews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view layoutIfNeeded];
        }
    }
}

- (void)_goToStep:(BSHighlightStep)step animated:(BOOL)animated animations:(ZPVoidBlock)animations {
    _currentStep = step;
    
    float width = _navigationViewStep1.superview.width;
    _navigationViewStep1LeadingConstraint.constant = _captureViewLeadingConstraint.constant = (-1 - step) * width;
    _navigationViewStep2LeadingConstraint.constant = _editViewLeadingConstraint.constant = (0 - step) * width;
    _navigationViewStep3LeadingConstraint.constant = _shareViewLeadingConstraint.constant = (1 - step) * width;
    [UIView animateWithDuration:animated ? kDefaultAnimateDuration : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _navigationViewStep1LeadingConstraint.constant = _captureViewLeadingConstraint.constant = (0 - step) * width;
        _navigationViewStep2LeadingConstraint.constant = _editViewLeadingConstraint.constant = (1 - step) * width;
        _navigationViewStep3LeadingConstraint.constant = _shareViewLeadingConstraint.constant = (2 - step) * width;
		if (animated)
			[self _layoutViews:@[_navigationViewStep1, _navigationViewStep2, _navigationViewStep3, _captureView, _editView, _shareView]];
        
        ZPInvokeBlock(animations);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_goToCaptureViewAnimated:(BOOL)animated {
	[_videoTrimmerView setMultiplyViewWork:NO];
	[self _pauseVideo];
	[self _updateCapturedDuration:0];
    [self.blockTimer resetStep];
	[_captureUrlSegments removeAllObjects];
    _btnCapture.selected = NO;
	_btnNavigationCancelStep1.enabled = _btnImportVideo.enabled = YES;
    _btnNavigationNextStep1.enabled = NO;
    _captureControlView.hidden = _captureBlendView.hidden = _btnRotateCamera.hidden = NO;
    _captureWaitingView.hidden = _videoDurationPromptView.hidden = _btnChooseSong.hidden = YES;
    
    [[NSFileManager defaultManager] removeItemAtURL:_videoUrl error:NULL];
    _videoUrl = _videoUrlProcessed = nil;
    
	[self _goToStep:BSHighlightStepCapture animated:animated animations:NULL];
	[self _checkAuthorizationStatus];
	
    _videoCapturer.previewView.hidden = NO;
	[_videoCapturer startSession];
    _videoPlaybackView.hidden = YES;
	
	self.songSelected = nil;
}

- (void)_setIsDetecting:(BOOL)detecting {
    _btnNavigationCancelStep1.enabled = _btnNavigationNextStep1.enabled = !detecting;
    _captureControlView.hidden = _lblCapturedDuration.hidden = detecting;
    _captureWaitingView.hidden = !detecting;
    if (detecting) {
        [_captureWaitingActivity startAnimating];
    } else {
        [_captureWaitingActivity stopAnimating];
    }
}

- (void)_goToHighlightDetectView {
	[self _setIsDetecting:YES];
	[self _removeAuthorizationView];
    _captureBlendView.hidden = _btnRotateCamera.hidden = YES;
}

- (void)_detectHighlight {
	// check if video is valid
	AVAsset *asset = [AVAsset assetWithURL:_videoUrl];
	NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
	if (tracks.count == 0) {
		[BSUIGlobal showAlertMessage:ZPLocalizedString(@"No video track found") cancelTitle:ZPLocalizedString(@"Go back") cancelHandler:^{
			[self _setIsDetecting:NO];
			[self _goToCaptureViewAnimated:YES];
		} actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
			[self _detectHighlight];
		}];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _highlightsDetected = [self.highlightDetector detectHighlights:_videoUrl expectedOutputHighlightsNumber:5];
            
            dispatch_main_async_safe(^{
                [self _setupTrimView];
                [self _updateVideoWithUrl:_videoUrl];
                [self _goToEditView];
                [self _setIsDetecting:NO];
            });
        });
    }
}

- (void)_goToEditView {
    _btnRotateCamera.hidden = YES;
	
    [self _goToStep:BSHighlightStepEdit animated:YES animations:nil];
    
    _videoPlaybackView.hidden = NO;
    _videoCapturer.previewView.hidden = YES;
	[_videoCapturer stopSession];
    
    [self _hideKeyboard];
	_btnPlay.hidden = NO;
	_btnChooseSong.hidden = !_isNOVideoEffect;
	
	if ([BSCapturePopupViewController ifCanShowTimelineInstruction]) {
		[BSCapturePopupViewController showTimelineInstructionWithCompletion:^{
			if (_currentStep == BSHighlightStepEdit && [BSCapturePopupViewController ifCanShowNOEffectInstruction]) {
				[BSCapturePopupViewController showNOEffectInstructionWithArrowPointInWindowCoordinate:[_videoTrimmerView highlightPointInWindowCoordinate]];
			}
		}];
	}
}

- (void)_goToShareView {
	[_videoTrimmerView setMultiplyViewWork:NO];
	[self _pauseVideo];
    [self _goToStep:BSHighlightStepShare animated:YES animations:nil];
	[self _loadLocationViewController];
	
	_btnPlay.hidden = _btnChooseSong.hidden = YES;
	[_txtDescription becomeFirstResponder];
}

- (void)_updateCapturedDuration:(float)duration {
    _videoDuration = duration;
    
	NSInteger hours = (duration / 3600);
	NSInteger minutes = (int)(duration / 60) % 60;
	NSInteger seconds = (int)duration % 60;
    _lblCapturedDuration.text = [NSString stringWithFormat:@"%02i:%02i:%02i", (int)hours, (int)minutes, (int)seconds];
    
    if (duration < kMinVideoDuration) {
		_captureBlendView.backgroundColor = [UIColor colorWithRed:.84 green:.24 blue:.11 alpha:.8];
		_btnNavigationNextStep1.enabled = NO;
    } else {
        _captureBlendView.backgroundColor = [BSUIGlobal multiplyBlendColor];
		_btnNavigationNextStep1.enabled = YES;
    }
}

#pragma mark - video view
- (IBAction)btnNavigationCancelStep1Tapped:(id)sender {
	[self _exitThisViewController];
}

- (IBAction)btnNavigationNextStep1Tapped:(UIButton *)sender {
	if (_isCapturing) {
		sender.enabled = NO;
		_needToGoToStep2 = YES;
		
		[self btnCaptureTapped:_btnCapture];
	} else {
		sender.enabled = YES;
		_needToGoToStep2 = NO;
		
		[self _goToHighlightDetectView];
		
		_videoUrl = [self _getVideoFileFullPathWithIsSegment:NO];
		_lblCaptureWaiting.text = ZPLocalizedString(@"Preparing video");
		[ZPVideoMerger mergeVideoWithUrls:_captureUrlSegments outputURL:_videoUrl presetName:AVAssetExportPresetPassthrough progressCallback:NULL completionCallback:^(NSError *error) {
			_lblCaptureWaiting.text = ZPLocalizedString(@"Locating the most excited moment");
			[self _detectHighlight];
		}];
	}
}

- (void)_captureDidFinishNotification {
	if (_needToGoToStep2) {
		[self btnNavigationNextStep1Tapped:_btnNavigationNextStep1];
	}
}

- (IBAction)btnNavigationCancelStep2Tapped:(id)sender {
	[self _goToCaptureViewAnimated:YES];
}

- (IBAction)btnNavigationNextStep2Tapped:(id)sender {
    [self _goToShareView];
}

- (IBAction)btnNavigationCancelStep3Tapped:(id)sender {
	[self _goToEditView];
}

- (IBAction)btnNavigationNextStep3Tapped:(UIButton *)sender {
    if (_txtDescription.text.length == 0) {
		[_txtDescription shakeAnimation];
        return;
    }
	
	[self _hideKeyboard];
	sender.enabled = NO;
	dispatch_main_async_safe(^{
		self.canPostAfterExport = NO;
		
		__weak typeof(self) weakSelf = self;
		_postViewController = [BSCapturePostViewController instanceFromStoryboard];
		_postViewController.postButtonTappedBlock = ^(UIButton *button) {
			button.enabled = NO;
			weakSelf.canPostAfterExport = YES;
			[weakSelf _post];
		};
		
		if ([self _isVideoExported]) {
			
		} else {
			[self _exportVideo];
		}
		
		[self.navigationController pushViewController:_postViewController animated:YES];
		sender.enabled = YES;
	});
}

- (IBAction)btnRotateCameraTapped:(UIButton *)sender {
	if (!_videoCapturer.isRecording) {
		sender.enabled = NO;
		[_videoCapturer rotateCameraWithCompletion:^(BOOL flag) {
			sender.enabled = YES;
		}];
	}
}

#pragma mark - capture
- (NSURL *)_getVideoFileFullPathWithIsSegment:(BOOL)isSegment {
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoTmp"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	NSString *fileName = isSegment ? [NSString stringWithFormat:@"highlight-%i.mp4", (int)_captureUrlSegments.count] : @"highlight.mp4";
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    return [NSURL fileURLWithPath:fullPath];
}

- (NSURL *)_getVideoProcessedFileFullPath {
    NSString *path = [[BSDataManager sharedInstance] getVideoFullPath];
    NSString *fullPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate timeIntervalSinceReferenceDate]]];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    return [NSURL fileURLWithPath:fullPath];
}

- (void)_showVideoDurationTooShortView:(BOOL)show {
    _videoDurationPromptView.hidden = NO;
    _videoDurationPromptView.alpha = show ? 0 : 1;
    [UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _videoDurationPromptView.alpha = show ? 1 : 0;
    } completion:^(BOOL finished) {
    }];
    
    if (show) {
        [self performSelector:@selector(hideVideoDurationTooShortView) withObject:nil afterDelay:3];
    }
}

- (IBAction)hideVideoDurationTooShortView {
    [self _showVideoDurationTooShortView:NO];
}

- (IBAction)btnCaptureTapped:(UIButton *)sender {
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
	if (status != AVAuthorizationStatusAuthorized) {
		BSAuthorizationViewController *vc = [BSAuthorizationViewController instanceFromDefaultNibWithType:BSAuthorizationTypeMicrophone];
		[vc showInViewController:self dismissCompletion:nil];
		return;
	}
	
    _isCapturing = !_isCapturing;
    sender.selected = _isCapturing;
	
	ZPVoidBlock completionBlock = ^ {
		_btnNavigationCancelStep1.enabled = _btnImportVideo.enabled = _btnRotateCamera.enabled = YES;
		if (_videoDuration < kMinVideoDuration) {
			_btnNavigationNextStep1.enabled = NO;
			[self _showVideoDurationTooShortView:YES];
		} else {
			_btnNavigationNextStep1.enabled = YES;
        }
        [self.blockTimer pause];
		
		_isCapturing = NO;
		sender.selected = NO;
	};
    if (_isCapturing) {
        _btnNavigationCancelStep1.enabled = _btnNavigationNextStep1.enabled =  _btnImportVideo.enabled = _btnRotateCamera.enabled = NO;
		
		_highlightsDetected = nil;
		if (!_captureUrlSegments) {
			_captureUrlSegments = [NSMutableArray array];
		}
        [_videoCapturer startRecordingToFileWithOutputUrlCallback:^NSURL *{
            NSURL *segmentUrl = [self _getVideoFileFullPathWithIsSegment:YES];
			[_captureUrlSegments addObject:segmentUrl];
			
            return segmentUrl;
        } recordCompletion:^(NSURL *fileUrl, NSError *error) {
			ZPLogDebug(@"recordCompletion");
		} clipCompletion:^(NSURL *fileUrl, NSError *error) {
			ZPLogDebug(@"clipCompletion");
			completionBlock();
			sender.enabled = YES;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kCaptureDidFinishNotification object:nil];
        }];
		
        [self.blockTimer startWithInterval:.2 tickBlock:^(float value) {
            [self _updateCapturedDuration:value];
        }];
    } else {
        sender.enabled = NO;
        [self.blockTimer pause];
        [_videoCapturer stopRecordingWithStartNewOne:NO];
    }
}

- (IBAction)btnImportVideoTapped:(id)sender {
	CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
	picker.assetsFilter = [ALAssetsFilter allVideos];
	picker.showsCancelButton = YES;
	picker.delegate = self;
	picker.showsNumberOfAssets = NO;
	[self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - play
- (void)_checkIfCanRegeratePlayItemWithCompletion:(ZPVoidBlock)completion {
	if (_needToRegeratePlayItem) {
        _needToRegeratePlayItem = NO;
		
		// update _effectModelSelected
		self.teamSelected = self.teamSelected;
		self.placeSelected = self.placeSelected;
        
        ZPVoidBlock buildComposition = ^ {
            THAdvancedComposition *composition = [self _buildComposition];
            AVPlayerItem *playerItem = [composition makePlayable];
			
			if (playerItem.titleLayer) {
				[_titleLayer removeFromSuperlayer];
				_titleLayer = playerItem.titleLayer;
				
				CGFloat scale = fminf(_videoPlaybackView.layer.width / _titleLayer.width, _videoPlaybackView.layer.height /_titleLayer.height);
				CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(_titleLayer.bounds.size, _videoPlaybackView.layer.bounds);
				_titleLayer.position = CGPointMake(CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
				_titleLayer.transform = CATransform3DMakeScale(scale, scale, 1);
				[_videoPlaybackView.layer addSublayer:_titleLayer];
			}

            [self.moviePlayer replaceCurrentItemWithPlayerItem:playerItem];
            
            ZPInvokeBlock(completion);
		};
		[[BSCoreImageManager sharedManager] generateImageForVideoUrl:_videoUrl size:kRenderedVideoSize withFilter:_effectModelSelected.filterType atTimes:[_effectModelSelected.compositionLayer timesPivotToHighlightFrameTime:_videoTrimmerView.selectedHighlightTime inputVideoDuration:_videoTrimmerView.inputVideoDuration] completion:^(NSArray *images) {
			_effectModelSelected.compositionLayer.imagesPivotToHighlightFrame = images;
			ZPInvokeBlock(buildComposition);
		}];
    } else {
        ZPInvokeBlock(completion);
    }
}

- (void)_playVideo {
	[self _checkIfCanRegeratePlayItemWithCompletion:^{
		[_moviePlayer play];
		[_btnPlay setImage:nil forState:UIControlStateNormal];
	}];
}

- (void)_pauseVideo {
	[_moviePlayer pause];
	[_btnPlay setImage:_btnPlay.imageDesignedOfNormal forState:UIControlStateNormal];
}

- (IBAction)btnPlayTapped:(id)sender {
    if (self.moviePlayer.isPlaying) {
        [self _pauseVideo];
    } else {
        [self _playVideo];
    }
}

- (IBAction)videoPlayerViewTapped:(id)sender {
    [self btnPlayTapped:sender];
}

- (void)_setLocationWithTitle:(NSString *)title {
	[_btnLocation setTitle:title forState:UIControlStateNormal];
	[_btnLocation setImage:title ? nil : _btnLocation.imageDesignedOfNormal forState:UIControlStateNormal];
}

- (NSString *)_setFirstLocation {
	BSHighlightPlaceDataModel *dm = [_chooseLocationViewController.placesDataModel.places firstObject];
	self.placeSelected = dm;
	return dm.nameLocalized;
}

- (void)_loadLocationViewController {
	if (_chooseLocationViewController == nil) {
		_chooseLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:BSCaptureChooseLocationViewController.className];
		__weak typeof(self) weakSelf = self;
		_chooseLocationViewController.selectedObjectDidChangedBlock = ^ (NSObject *object) {
			weakSelf.placeSelected = object;
		};
		_chooseLocationViewController.didStartRequest = ^ {
			[weakSelf _setLocationWithTitle:ZPLocalizedString(@"Updating Location...")];
		};
		_chooseLocationViewController.didSuccessRequest = ^ {
			NSString *name = [weakSelf _setFirstLocation];
			[weakSelf _setLocationWithTitle:name];
		};
		_chooseLocationViewController.didFaildRequest = ^ {
			[weakSelf _setLocationWithTitle:nil];
		};
		[_chooseLocationViewController view];
	}
}

- (IBAction)btnLocationTapped:(id)sender {
	_chooseLocationViewController.selectedObject = _placeSelected;
	[self.navigationController pushViewController:_chooseLocationViewController animated:YES];
	
	[self _hideKeyboard];
}

#pragma mark - timeline editor
- (void)_setupComposition {
	if (!_compositionBuilder) {
		_timeline = [[THTimeline alloc] init];
		
		_compositionBuilder = [[THAdvancedCompositionBuilder alloc] initWithTimeline:_timeline];
		_compositionBuilder.renderSize = kRenderedVideoSize;
		_compositionBuilder.frameRate = kRenderedVideoFrameRate;
	}
}

- (THAdvancedComposition *)_buildComposition {
	THAdvancedComposition *advancedComposition = (THAdvancedComposition *)[_compositionBuilder buildComposition];
	((AVMutableVideoComposition *)advancedComposition.videoComposition).customVideoCompositorClass = _effectModelSelected.videoCompositorClass;
	return advancedComposition;
}

- (void)_updateVideoWithUrl:(NSURL *)url {
	_effectModelSelected = [BSHighlightEffectManager sharedInstance].noEffectModel;
	[_effectModelSelected updateVideoWithUrl:url completion:nil];
	[self _setEffectWithModel:_effectModelSelected forced:YES];
	[_editEffectCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];

	CMTimeRange timeRangeBackup = _effectModelSelected.videoItemDefault.timeRange;
	_effectModelSelected.videoItemDefault.timeRange = CMTimeRangeMake(kCMTimeZero, _effectModelSelected.videoItemDefault.asset.duration);
	THAdvancedComposition *composition = [self _buildComposition];
	_playerItemNormal = [composition makePlayable];
	_effectModelSelected.videoItemDefault.timeRange = timeRangeBackup;
}

- (void)_setEffectWithModel:(BSHighlightBaseEffectModel *)model forced:(BOOL)forced {
	if (forced || _effectModelSelected != model) {
		[self _pauseVideo];
		
		[model updateVideoWithVideoItem:_effectModelSelected.videoItemDefault];
		_effectModelSelected = model;
		
		_timeline.videos = _effectModelSelected.videoItems;
		_timeline.titles = _effectModelSelected.titleItems;
		_timeline.musicItems = _effectModelSelected.musicItems;
		if ([_effectModelSelected isKindOfClass:[BSHighlightEffectModel0 class]]) {
			[_videoTrimmerView setNOEffectMode];
			_isNOVideoEffect = YES;
			_btnChooseSong.hidden = NO;
		} else {
			[_videoTrimmerView setEffectModeWithSelectionDuration:_effectModelSelected.requiredVideoDuration];
			
			if (_currentStep == BSHighlightStepEdit && [BSCapturePopupViewController ifCanShowEffectInstruction]) {
				[BSCapturePopupViewController showEffectInstructionWithArrowPointInWindowCoordinate:[_videoTrimmerView heroFramePointInWindowCoordinate]];
			}
			_isNOVideoEffect = NO;
			_btnChooseSong.hidden = YES;
        }
        _needToRegeratePlayItem = YES;
        [self _checkIfCanRegeratePlayItemWithCompletion:NULL];
    }
}

#pragma mark - edit view
- (void)_setupColorForSubView:(UIView *)view {
	for (UIView *subView in view.subviews) {
		if ([NSStringFromClass([subView class]) isEqualToString:@"ICGThumbView"]) {
			subView.superview.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
		} else if ([NSStringFromClass([subView class]) isEqualToString:@"ICGRulerView"]) {
			subView.backgroundColor = [UIColor whiteColor];
		}
		[self _setupColorForSubView:subView];
	}
}

- (void)_setupTrimView {
	if (!_videoTrimmerView) {
		_videoTrimmerView = [BSVideoTrimmerView videoTrimmerViewFromNib];
		_videoTrimmerView.delegate = self;
		_videoTrimmerView.translatesAutoresizingMaskIntoConstraints = NO;
		[_videoTrimmerHostView addSubview:_videoTrimmerView];
		[_videoTrimmerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
	}
	
	float selectedBeginTime = 0;
	float selectedEndTime = 5;
	float highlightTime;
	VkHighlight *highlightRange = [_highlightsDetected firstObject];
	if (highlightRange.beginTimeMs >= 0 && highlightRange.endTimeMs > 0 && highlightRange.endTimeMs > highlightRange.beginTimeMs) {
		selectedBeginTime = highlightRange.beginTimeMs / 1000.;
		selectedEndTime = highlightRange.endTimeMs / 1000.;
		float duration = selectedEndTime - selectedBeginTime;
		highlightTime = selectedBeginTime + duration / 2;
		
		if (duration < kMinVideoDuration) {
			float expand = (kMinVideoDuration - duration) / 2;
			if (selectedBeginTime - expand < 0) {
				selectedBeginTime = 0;
				selectedEndTime = kMinVideoDuration;
			} else {
				selectedBeginTime -= expand;
				selectedEndTime += expand;
			}
		} else if (duration > kRenderedVideoDuration) {
			float expand = (kRenderedVideoDuration - duration) / 2;
			selectedBeginTime += expand;
			selectedEndTime += expand;
		}
	} else {
		highlightTime = (selectedEndTime - selectedBeginTime) / 2;
	}
	
	[_videoTrimmerView configNOEffectModeWithAsset:[AVAsset assetWithURL:_videoUrl] minVideoDuration:5 maxVideoDuration:kRenderedVideoDuration selectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime highlightTime:highlightTime];
	[_videoTrimmerView setMultiplyViewWork:YES];
}

- (void)_didChangedSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime {
	[_effectModelSelected didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime selectedHighlightTime:_videoTrimmerView.selectedHighlightTime inputVideoDuration:_videoTrimmerView.inputVideoDuration];
	
	double tolerance = _videoTrimmerView.inputVideoDuration / _videoTrimmerView.width;
	[self.moviePlayer seekToTime:cmTimeWithSeconds(_videoTrimmerView.selectedHighlightTime) toleranceBefore:cmTimeWithSeconds(tolerance) toleranceAfter:cmTimeWithSeconds(tolerance)];
	
	[self _cancelPreviousExportVideo];
	_needToRegeratePlayItem = YES;
}

- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didBeginChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime {
	[self _pauseVideo];
	if (!_isNOVideoEffect) {
//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		dispatch_async(dispatch_get_main_queue(), ^ {
			_playerItemWithEffect = self.moviePlayer.currentItem;
			[self.moviePlayer replaceCurrentItemWithPlayerItem:_playerItemNormal];
			ZPLogDebug(@"start replaceCurrentItemWithPlayerItem, current:%p, new:%p", _playerItemWithEffect, _playerItemNormal);
		});
	}
	[self _didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime];
}

- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime {
	[self _didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime];
}

- (void)videoTrimmerView:(BSVideoTrimmerView *)videoTrimmerView didEndChangeSelectedBeginTime:(CGFloat)selectedBeginTime selectedEndTime:(CGFloat)selectedEndTime {
	[self _didChangedSelectedBeginTime:selectedBeginTime selectedEndTime:selectedEndTime];
	[self _playVideo];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [BSHighlightEffectManager sharedInstance].highlightEffectModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSHighlightEffectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSHighlightEffectCollectionViewCell.className forIndexPath:indexPath];
    [cell configWithHighlightEffectModel:[BSHighlightEffectManager sharedInstance].highlightEffectModels[indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self _setEffectWithModel:[BSHighlightEffectManager sharedInstance].highlightEffectModels[indexPath.row] forced:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 70);
}

#pragma mark - BSPlayerDelegate
- (void)player:(BSPlayer *)player didChangeItem:(AVPlayerItem *)item {
//	ZPLogDebug(@"player didChangeItem:%p", item);
}

- (void)player:(BSPlayer *)player didReachEndForItem:(AVPlayerItem *)item {
	[self _pauseVideo];
}

- (void)player:(BSPlayer *)player didPlay:(CMTime)currentTime {
	[_videoTrimmerView setCursorTime:CMTimeGetSeconds(currentTime) duration:CMTimeGetSeconds(player.itemDuration)];
}

#pragma mark - CTAssetsPickerControllerDelegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group {
	return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldShowAsset:(ALAsset *)asset {
	if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
		NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
		return lround(duration) >= 5;
	} else {
		return NO;
	}
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset {
	if (_currentSelectedAsset && _currentSelectedAsset != asset) {
		CTAssetsViewController *vc = (CTAssetsViewController *)picker.childNavigationController.topViewController;
		NSUInteger index = [vc.assets indexOfObject:_currentSelectedAsset];
		
		[picker deselectAsset:_currentSelectedAsset];
		[vc.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
	}
	_currentSelectedAsset = asset;
	
	return YES;
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
	if (assets.count) {
		[self _showExportingHud];
		
		ALAsset *asset = [assets firstObject];
		ALAssetRepresentation* representation = asset.defaultRepresentation;
		AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[AVURLAsset URLAssetWithURL:representation.url options:nil] presetName:AVAssetExportPresetPassthrough];
		exportSession.outputFileType=AVFileTypeQuickTimeMovie;
		exportSession.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mov",[NSDate timeIntervalSinceReferenceDate]]]];
		AVAssetExportSession *_exportSession = exportSession;
		
		[exportSession exportAsynchronouslyWithProgress:^(float value) {
			_hud.progress = value;
		} completionHandler:^{
			dispatch_main_sync_safe(^ {
				[_hud hide:YES];
				
				if (_exportSession.status == AVAssetExportSessionStatusCompleted) {
					_videoUrl = _exportSession.outputURL;
					[self _goToHighlightDetectView];
					[self _detectHighlight];
					
					[picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
				} else {
					[BSUIGlobal showError:_exportSession.error];
					ZPLogDebug(@"Export video error: %@", _exportSession.error);
				}
			});
		}];
	} else {
		[BSUIGlobal showMessage:ZPLocalizedString(@"Import video error, please try again")];
	}
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldShowAssetsGroup:(ALAssetsGroup *)group {
	return group.numberOfAssets > 0;
}

@end
