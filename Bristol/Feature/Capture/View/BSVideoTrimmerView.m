//
//  BSVideoTrimmerView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSVideoTrimmerView.h"
#import "BSVideoTrimmerThumbnailCollectionViewCell.h"
#import "FXBlurView.h"
#import "UIImage+Resize.h"

@interface BSVideoTrimmerView()<UICollectionViewDelegate>
{
	CGFloat _selectedBeginTime, _selectedEndTime, _minVideoDuration, _maxVideoDuration, _highlightTime;
	AVAsset *_asset;
	
	CGFloat _thumbnailScale;
	CGFloat _durationPerCell;
	CGFloat _durationWidthRatio;
	CGFloat _collectionViewFGMinWidth;
	CGFloat _collectionViewFGMaxWidth;
	CGFloat _imgViewHighlightLeftToCollectionViewFG;
    CGFloat _effectModeWithSelectionDuration;
    CGFloat _effectModeMinCenterX;
    CGFloat _effectModeMaxCenterX;
	CGSize _foregroundCellSize;
	NSInteger _numberOfCells;
	BOOL _isConfigurationFinish, _isChangingTimelineFrame, _isEffectModeUI;
	dispatch_queue_t _videoThumbnailQueue;
}

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) NSMutableDictionary *dicThumbnails;
@property (nonatomic, assign) BOOL isEffectModeUI;
@property (nonatomic, assign) CGSize foregroundCellSize;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBGHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBGLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBGTrailingConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewFGWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewFGHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewFGLeadingConstraint;

@property (weak, nonatomic) IBOutlet UIView *leftDraggerView;
@property (weak, nonatomic) IBOutlet FXBlurView *leftMultiplyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDraggerViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *leftDraggerViewPanGesture;

@property (weak, nonatomic) IBOutlet UIView *rightDraggerView;
@property (weak, nonatomic) IBOutlet FXBlurView *rightMultiplyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightDraggerViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *rightDraggerViewPanGesture;

@property (weak, nonatomic) IBOutlet FXBlurView *cursorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cursorViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewHighlight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHighlightVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHighlightLeadingConstraint;

@end


#define kForegroundBackgroundCellRatio (1.4)
#define kDraggerToBoundSpan (30)

typedef NS_ENUM(NSUInteger, BSVideoTrimmerViewCallbackType) {
	BSVideoTrimmerViewCallbackTypeBegin,
	BSVideoTrimmerViewCallbackTypeOnProgress,
	BSVideoTrimmerViewCallbackTypeEnd
};


@implementation BSVideoTrimmerView

+ (instancetype)videoTrimmerViewFromNib {
	return [[UINib nibWithNibName:@"BSVideoTrimmerView" bundle:nil] instantiateWithOwner:nil options:nil][0];
}

- (void)_commitInit {
	[_collectionViewBG registerNib:[UINib nibWithNibName:@"BSVideoTrimmerThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[BSVideoTrimmerThumbnailCollectionViewCell className]];
	[_collectionViewFG registerNib:[UINib nibWithNibName:@"BSVideoTrimmerThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[BSVideoTrimmerThumbnailCollectionViewCell className]];
	
	_videoThumbnailQueue = dispatch_queue_create("com.zepp.bristol.videoThumbnail", DISPATCH_QUEUE_SERIAL);
	_thumbnailScale = [UIScreen mainScreen].scale;
}

- (void)awakeFromNib {
	[self _commitInit];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)configNOEffectModeWithAsset:(AVAsset *)asset minVideoDuration:(NSTimeInterval)minVideoDuration maxVideoDuration:(NSTimeInterval)maxVideoDuration selectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime highlightTime:(NSTimeInterval)highlightTime {
	minVideoDuration = fabs(minVideoDuration);
	maxVideoDuration = fabs(maxVideoDuration);
	selectedBeginTime = fabs(selectedBeginTime);
	selectedEndTime = fabs(selectedEndTime);
	highlightTime = fabs(highlightTime);
	
	BOOL paramValid = YES;
	_inputVideoDuration = CMTimeGetSeconds(asset.duration);
	if (!(minVideoDuration <= _inputVideoDuration))
		paramValid = NO;
	if (!(minVideoDuration <= maxVideoDuration))
		paramValid = NO;
	if (!(selectedBeginTime < selectedEndTime))
		paramValid = NO;
	if (!(selectedBeginTime < _inputVideoDuration))
		paramValid = NO;
	CGFloat durationSelected = selectedEndTime - selectedBeginTime;
	if (!(durationSelected <= _inputVideoDuration && durationSelected >= minVideoDuration && durationSelected <= maxVideoDuration))
		paramValid = NO;
	if (!paramValid) {
		ZPLogDebug(@"video trimmer param is not valid");
		return;
	}
	
	if (maxVideoDuration > _inputVideoDuration) {
		maxVideoDuration = _inputVideoDuration;
	}
	_asset = asset;
	_minVideoDuration = minVideoDuration;
	_maxVideoDuration = maxVideoDuration;
	_selectedBeginTime = selectedBeginTime;
	_selectedEndTime = selectedEndTime;
	_highlightTime = highlightTime;
	
	_imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
	_imageGenerator.appliesPreferredTrackTransform = YES;
	[self layoutIfNeeded];
	
	AVAssetTrack *track = [[_asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
	CGSize naturalSize = track.naturalSize;
	CGAffineTransform preferredTransform = track.preferredTransform;
	CGRect outRect = CGRectApplyAffineTransform(CGRectMake(0, 0, naturalSize.width, naturalSize.height), preferredTransform);
	outRect = rectScaleAspectFillSizeInSize(outRect.size, CGSizeMake(_collectionViewFG.height, _collectionViewFG.height));
	_imageGenerator.maximumSize = outRect.size;
	
	_dicThumbnails = [NSMutableDictionary dictionary];
	
	[self _configNOEffectMode];
}

- (void)_configNOEffectMode {
	[self layoutIfNeeded];
	_isConfigurationFinish = NO;
	
	_foregroundCellSize = CGSizeMake(_collectionViewFG.height, _collectionViewFG.height);
	_collectionViewFGMaxWidth = self.width - kDraggerToBoundSpan * 2 - _leftMultiplyView.width * 2;
	_durationWidthRatio = _maxVideoDuration / _collectionViewFGMaxWidth;
	_collectionViewFGMinWidth = _minVideoDuration / _durationWidthRatio;
	
	_imgViewHighlightLeftToCollectionViewFG = _highlightTime / _durationWidthRatio;
	CGFloat durationSelected = _selectedEndTime - _selectedBeginTime;
	CGFloat collectionViewFGCurrentWidth = durationSelected / _durationWidthRatio;
	[self _setNOEffectModeWithCollectionViewFGWidth:collectionViewFGCurrentWidth];
	
	CGFloat durationAsset = CMTimeGetSeconds(_asset.duration);
	_durationPerCell = _foregroundCellSize.width * _durationWidthRatio;
	CGFloat cells = durationAsset / _durationPerCell;
	_numberOfCells = ceilf(cells);
	CGFloat exceedCells = _numberOfCells - cells;
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewFG.collectionViewLayout;
	CGFloat cellSpacing = layout.minimumInteritemSpacing * floorf(cells);
	_collectionViewFG.delegate = nil;
	_collectionViewFG.contentInset = UIEdgeInsetsMake(0, 0, 0, -exceedCells * _foregroundCellSize.width - cellSpacing);
	_collectionViewFG.contentOffset = CGPointMake(_selectedBeginTime / _durationWidthRatio, 0);
	_collectionViewFG.delegate = self;
	
	[self scrollViewDidScroll:_collectionViewFG];
	_isConfigurationFinish = YES;
	[self _reloadCollectionView];
}

- (void)_configEffectMode {
	[self layoutIfNeeded];
	_isConfigurationFinish = NO;
	
	CGFloat durationAsset = CMTimeGetSeconds(_asset.duration);
	_durationWidthRatio = durationAsset / _collectionViewBG.width;
	_imgViewHighlightLeadingConstraint.constant = _highlightTime / _durationWidthRatio;
	
	float width = _effectModeWithSelectionDuration / _durationWidthRatio;
	_collectionViewFGWidthConstraint.constant = width;
	_effectModeMinCenterX = kDraggerToBoundSpan + width / 2;
	_effectModeMaxCenterX = self.width - _effectModeMinCenterX;
	float centerX = _imgViewHighlightLeadingConstraint.constant;
	if (centerX < _effectModeMinCenterX) {
		centerX = _effectModeMinCenterX;
	} else if (centerX > _effectModeMaxCenterX) {
		centerX = _effectModeMaxCenterX;
	}
	[self layoutIfNeeded];
	[self _setEffectModeWithLeftDraggerViewCenterX:centerX];
	
	_lblDuration.text = ZPLocalizedString(@"PICK YOUR HERO FRAME");
	
	_foregroundCellSize = CGSizeMake(_collectionViewFG.height, _collectionViewFG.height);
	_durationPerCell = _foregroundCellSize.width * _durationWidthRatio;
	CGFloat cells = durationAsset / _durationPerCell;
	_numberOfCells = ceilf(cells);
	CGFloat exceedCells = _numberOfCells - cells;
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionViewFG.collectionViewLayout;
	CGFloat cellSpacing = layout.minimumInteritemSpacing * floorf(cells);
	_collectionViewFG.delegate = _collectionViewBG.delegate = nil;
	_collectionViewFG.contentInset = _collectionViewBG.contentInset = UIEdgeInsetsMake(0, 0, 0, -exceedCells * _foregroundCellSize.width - cellSpacing);
	_collectionViewBG.contentOffset = CGPointZero;
	_collectionViewFG.delegate = _collectionViewBG.delegate = self;
	[self layoutIfNeeded];
	
	[self scrollViewDidScroll:_collectionViewFG];
	_isConfigurationFinish = YES;
	[self _reloadCollectionView];
}

- (void)setCursorTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
	if (duration == 0) {
		return;
	}
	
	if (!_isChangingTimelineFrame) {
		if (time < 0) {
			time = 0;
		} else if (time > duration) {
			time = duration;
		} else if (duration == 0) {
			return;
		}
		
		_cursorViewLeadingConstraint.constant = (time / duration) * (_selectedEndTime - _selectedBeginTime) / _durationWidthRatio;
	}
}

- (void)_setMultiplyView:(FXBlurView *)view work:(BOOL)isWork {
	if ([view isKindOfClass:[FXBlurView class]]) {
		view.dynamic = isWork;
	}
}

- (void)setMultiplyViewWork:(BOOL)isWork {
	[self _setMultiplyView:_leftMultiplyView work:isWork];
	[self _setMultiplyView:_rightMultiplyView work:isWork];
	[self _setMultiplyView:_cursorView work:isWork];
}

- (void)setIsEffectModeUI:(BOOL)isEffectModeUI {
	if (_isEffectModeUI == isEffectModeUI) {
		return;
	}
    _isEffectModeUI = isEffectModeUI;
    
    float multiplier = _collectionViewBGHeightConstraint.multiplier;
    if (!isEffectModeUI) {
        multiplier *= kForegroundBackgroundCellRatio;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_collectionViewFGHeightConstraint.firstItem attribute:_collectionViewFGHeightConstraint.firstAttribute relatedBy:_collectionViewFGHeightConstraint.relation toItem:_collectionViewFGHeightConstraint.secondItem attribute:_collectionViewFGHeightConstraint.secondAttribute multiplier:multiplier constant:_collectionViewBGHeightConstraint.constant];
    [_collectionViewFG.superview removeConstraint:_collectionViewFGHeightConstraint];
    [_collectionViewFG.superview addConstraint:constraint];
    _collectionViewFGHeightConstraint = constraint;
    
    if (isEffectModeUI) {
        _rightDraggerView.hidden = YES;
		_rightDraggerViewPanGesture.enabled = NO;
		_collectionViewBG.scrollEnabled = NO;
		_collectionViewBGLeadingConstraint.constant = _collectionViewBGTrailingConstraint.constant = kDraggerToBoundSpan;
		_collectionViewFG.scrollEnabled = NO;
    } else {
        _rightDraggerView.hidden = NO;
		_rightDraggerViewPanGesture.enabled = YES;
		_collectionViewBG.scrollEnabled = YES;
		_collectionViewBGLeadingConstraint.constant = _collectionViewBGTrailingConstraint.constant = 0;
		_collectionViewFG.scrollEnabled = YES;
    }
}

- (void)setEffectModeWithSelectionDuration:(NSTimeInterval)duration {
	_effectModeWithSelectionDuration = duration;
    [self setIsEffectModeUI:YES];
	[self _configEffectMode];
	[self _informCallbackWithCallbackType:BSVideoTrimmerViewCallbackTypeOnProgress];
}

- (void)setNOEffectMode {
	[self setIsEffectModeUI:NO];
	[self _configNOEffectMode];
	[self _informCallbackWithCallbackType:BSVideoTrimmerViewCallbackTypeOnProgress];
}

- (void)_setNOEffectModeWithCollectionViewFGWidth:(CGFloat)width {
	CGFloat padding = (self.width - width) / 2 - (_leftDraggerView.width + _leftMultiplyView.width) / 2;
	_leftDraggerViewLeadingConstraint.constant = _rightDraggerViewTrailingConstraint.constant = padding;
	padding = (self.width - width) / 2;
    _collectionViewFGWidthConstraint.constant = width;
	_collectionViewFGLeadingConstraint.constant = padding;
	_cursorViewLeadingConstraint.constant = 0;
    padding -= _leftMultiplyView.width;
	_collectionViewBG.delegate = nil;
	_collectionViewBG.contentInset = UIEdgeInsetsMake(0, padding, 0, padding - _collectionViewFG.contentInset.right - _leftMultiplyView.width);
	_collectionViewBG.delegate = self;
	
	[self layoutIfNeeded];
	
	[self _contentOffsetFGDidChanged];
	
	CGFloat duration = width * _durationWidthRatio;
	_lblDuration.text = [NSString stringWithFormat:@"%.0f''", duration];
}

- (void)_setEffectModeWithLeftDraggerViewCenterX:(float)centerX {
	_leftDraggerViewLeadingConstraint.constant = centerX - _leftDraggerView.width / 2;
	
	float centerXAdjusted = centerX;
	if (centerX < _effectModeMinCenterX)
		centerXAdjusted = _effectModeMinCenterX;
	if (centerX > _effectModeMaxCenterX)
		centerXAdjusted = _effectModeMaxCenterX;
	_collectionViewFGLeadingConstraint.constant = centerXAdjusted - _collectionViewFG.width / 2;
	_collectionViewFG.contentOffset = CGPointMake(_collectionViewFGLeadingConstraint.constant - _collectionViewBGLeadingConstraint.constant, 0);
	_cursorViewLeadingConstraint.constant = centerX - _collectionViewFGLeadingConstraint.constant;
	
	[self _updateHighlightImage];
}

- (void)_reloadCollectionView {
    [_collectionViewBG reloadData];
    [_collectionViewFG reloadData];
}

- (void)_informCallbackWithCallbackType:(BSVideoTrimmerViewCallbackType)callbackType {
	_selectedBeginTime = _collectionViewFG.contentOffset.x * _durationWidthRatio;
	_selectedEndTime = _selectedBeginTime + _collectionViewFG.width * _durationWidthRatio;
	if (callbackType == BSVideoTrimmerViewCallbackTypeBegin) {
		if ([_delegate respondsToSelector:@selector(videoTrimmerView:didBeginChangeSelectedBeginTime:selectedEndTime:)]) {
			[_delegate videoTrimmerView:self didBeginChangeSelectedBeginTime:_selectedBeginTime selectedEndTime:_selectedEndTime];
		}
	} else if (callbackType == BSVideoTrimmerViewCallbackTypeOnProgress) {
		if ([_delegate respondsToSelector:@selector(videoTrimmerView:didChangeSelectedBeginTime:selectedEndTime:)]) {
			[_delegate videoTrimmerView:self didChangeSelectedBeginTime:_selectedBeginTime selectedEndTime:_selectedEndTime];
		}
	} else {
		if ([_delegate respondsToSelector:@selector(videoTrimmerView:didEndChangeSelectedBeginTime:selectedEndTime:)]) {
			[_delegate videoTrimmerView:self didEndChangeSelectedBeginTime:_selectedBeginTime selectedEndTime:_selectedEndTime];
		}
	}
//	ZPLogDebug(@"did select beginTime:%.3f, endTime:%.3f, duration:%.3f, highlightTime:%.3f", _selectedBeginTime, _selectedEndTime, _selectedEndTime - _selectedBeginTime, self.selectedHighlightTime);
}

- (IBAction)_handleGesture:(UIPanGestureRecognizer *)recognizer {
	BOOL isLeftGesture = recognizer == _leftDraggerViewPanGesture;
    UIGestureRecognizer *anotherGesture = nil;
    if (!_isEffectModeUI) {
        anotherGesture = isLeftGesture ? _rightDraggerViewPanGesture : _leftDraggerViewPanGesture;
    }
	switch (recognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			anotherGesture.enabled = NO;
			_isChangingTimelineFrame = YES;
			[self _informCallbackWithCallbackType:BSVideoTrimmerViewCallbackTypeBegin];
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			CGPoint point = [recognizer translationInView:self];
            if (_isEffectModeUI) {
                CGFloat centerXTarget = _leftDraggerView.centerX + point.x;
                if (centerXTarget < _collectionViewBG.left) {
                    [self _setEffectModeWithLeftDraggerViewCenterX:_collectionViewBGLeadingConstraint.constant];
                } else if (centerXTarget > _collectionViewBG.right) {
                    [self _setEffectModeWithLeftDraggerViewCenterX:_collectionViewBG.right];
                } else {
                    [self _setEffectModeWithLeftDraggerViewCenterX:centerXTarget];
                }
            } else {
                CGFloat widthDelta = point.x * 2;
                if (isLeftGesture) {
                    widthDelta *= -1;
                }
                CGFloat widthTarget = _collectionViewFG.width + widthDelta;
                if (widthTarget < _collectionViewFGMinWidth) {
                    [self _setNOEffectModeWithCollectionViewFGWidth:_collectionViewFGMinWidth];
                } else if (widthTarget > _collectionViewFGMaxWidth) {
                    [self _setNOEffectModeWithCollectionViewFGWidth:_collectionViewFGMaxWidth];
                } else {
                    [self _setNOEffectModeWithCollectionViewFGWidth:widthTarget];
                }
            }
            
			[recognizer setTranslation:CGPointZero inView:self];
			[self _informCallbackWithCallbackType:BSVideoTrimmerViewCallbackTypeOnProgress];
			break;
		}
		default:
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			anotherGesture.enabled = YES;
			_isChangingTimelineFrame = NO;
            
            if (_isEffectModeUI) {
                [self _setEffectModeWithLeftDraggerViewCenterX:_leftDraggerView.centerX];
            } else {
                [self _setNOEffectModeWithCollectionViewFGWidth:_collectionViewFG.width];
            }
            
			[self _informCallbackWithCallbackType:BSVideoTrimmerViewCallbackTypeEnd];
			break;
	}
}

- (CGPoint)highlightPointInWindowCoordinate {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	CGPoint point = CGPointMake(_imgViewHighlight.right, _imgViewHighlight.centerY);
	point = [_imgViewHighlight.superview convertPoint:point toView:window];
	return point;
}

- (CGPoint)heroFramePointInWindowCoordinate {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	CGPoint point = CGPointMake(_leftDraggerView.right, _leftDraggerView.centerY + _leftDraggerView.height * 0.25);
	point = [_leftDraggerView.superview convertPoint:point toView:window];
	return point;
}

#pragma mark - property
- (NSTimeInterval)selectedHighlightTime {
	if (_isEffectModeUI) {
		CGFloat time = (_leftDraggerView.centerX - _collectionViewBG.left) * _durationWidthRatio;
		return time;
	} else {
		return _selectedBeginTime;
	}
}

#pragma mark - thumbnail
- (void)generateThumbnailAtTime:(NSTimeInterval)time completion:(ZPImageBlock)completion {
	dispatch_async(_videoThumbnailQueue, ^{
		NSError *error = nil;
		CGImageRef cgImage = [_imageGenerator copyCGImageAtTime:cmTimeWithSeconds(time) actualTime:NULL error:&error];
		UIImage *image = [UIImage imageWithCGImage:cgImage scale:_thumbnailScale orientation:UIImageOrientationUp];
		CFRelease(cgImage);
		
		if (error) {
			ZPLogError(@"generate thumbnail at time:%f, error:%@", time, error);
		}
		
		dispatch_main_async_safe(^ {
			ZPInvokeBlock(completion, image);
		});
	});
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (_asset) {
		return _numberOfCells;
	} else {
		return 0;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	BSVideoTrimmerThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSVideoTrimmerThumbnailCollectionViewCell.className forIndexPath:indexPath];
	
	BOOL showMask = collectionView == _collectionViewBG;
	NSNumber *key = @(indexPath.row);
	id object = _dicThumbnails[key];
	if (!object) {
		_dicThumbnails[key] = [NSNull null];
		
		CGFloat time = indexPath.row * _durationPerCell;
		[self generateThumbnailAtTime:time completion:^(UIImage *image) {
			ZPLogDebug(@"collectionView:%@, index:%i, image:%@", showMask ? @"BG" : @"FG", (int)indexPath.row, image);
			if (image) {
				_dicThumbnails[key] = image;
			} else {
				[_dicThumbnails removeObjectForKey:key];
			}
			[cell setThumbnail:image showMask:showMask];
			
			[self _reloadCollectionView];
		}];
	} else {
		if ([object isKindOfClass:[UIImage class]]) {
			[cell setThumbnail:(UIImage *)object showMask:showMask];
		}
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(collectionView.height, collectionView.height);
}

#pragma mark - UIScrollViewDelegate
- (void)_updateHighlightImage {
	CGAffineTransform transform;
	CGFloat alpha = 0;
	CGFloat left = 0, bottom = 0;
	CGFloat const MaxScale = 1;
	CGFloat const MinScale = .6;
	CGFloat const MaxBottom = 9;
	CGFloat MinBottom = -((_collectionViewFG.height - _collectionViewBG.height)/2 - 2);
	
	CGFloat scaleDistance;
	CGFloat distance;
	if (_isEffectModeUI) {
		distance = _leftDraggerView.centerX - _imgViewHighlight.centerX;
		distance = fabs(distance);
		scaleDistance = _leftMultiplyView.width / 2;
		
		CGFloat delta = distance / scaleDistance; // [0, 1]
		delta = delta > 1 ? 1 : delta;
		CGFloat scale = MaxScale - delta * (MaxScale - MinScale); // [1, 0.5]
		transform = CGAffineTransformMakeScale(scale, scale);
		alpha = scale;
		bottom = MaxBottom - delta * (MaxBottom - MinBottom);
	} else {
		distance = _imgViewHighlightLeftToCollectionViewFG - _collectionViewFG.contentOffset.x;
		scaleDistance = _leftMultiplyView.width;
		
		if (distance >= 0 && distance <= _collectionViewFG.width) {
			transform = CGAffineTransformIdentity;
			alpha = 1;
			left = _collectionViewFG.left + distance;
			bottom = MaxBottom;
		} else if (distance > -scaleDistance && distance < 0) {
			CGFloat delta = -distance / scaleDistance; // [0, 1]
			CGFloat scale = MaxScale - delta * (MaxScale - MinScale); // [1, 0.5]
			transform = CGAffineTransformMakeScale(scale, scale);
			alpha = scale;
			left = _collectionViewFG.left + distance / kForegroundBackgroundCellRatio;
			bottom = MaxBottom - delta * (MaxBottom - MinBottom);
		} else if (distance > _collectionViewFG.width && distance < _collectionViewFG.width + scaleDistance) {
			CGFloat delta = (distance - _collectionViewFG.width) / scaleDistance; // [0, 1]
			CGFloat scale = MaxScale - delta * (MaxScale - MinScale); // [1, 0.5]
			transform = CGAffineTransformMakeScale(scale, scale);
			alpha = scale;
			left = _collectionViewFG.right + (distance - _collectionViewFG.width) / kForegroundBackgroundCellRatio;
			bottom = MaxBottom - delta * (MaxBottom - MinBottom);
		} else {
			transform = CGAffineTransformMakeScale(MinScale, MinScale);
			alpha = MinScale;
			if (distance < -scaleDistance) {
				left = _collectionViewFG.left + distance / kForegroundBackgroundCellRatio;
				if (left < 0)
					left = 0;
			} else {
				left = _collectionViewFG.right + (distance - _collectionViewFG.width) / kForegroundBackgroundCellRatio;
				if (left > self.width - _imgViewHighlight.width)
					left = self.width - _imgViewHighlight.width;
			}
			bottom = MinBottom;
		}
	}
	
	_imgViewHighlight.transform = transform;
	_imgViewHighlight.alpha = alpha;
	_imgViewHighlightVerticalConstraint.constant = bottom;
	if (_isEffectModeUI) {
		
	} else {
		_imgViewHighlightLeadingConstraint.constant = left;
	}
}

- (void)_contentOffsetFGDidChanged {
	_collectionViewBG.delegate = nil;
	_collectionViewBG.contentOffset = CGPointMake(_collectionViewFG.contentOffset.x / kForegroundBackgroundCellRatio - _collectionViewBG.contentInset.left, 0);
	_collectionViewBG.delegate = self;
	
	[self _updateHighlightImage];
}

- (void)_contentOffsetBGDidChanged {
	_collectionViewFG.delegate = nil;
	_collectionViewFG.contentOffset = CGPointMake((_collectionViewBG.contentOffset.x + _collectionViewBG.contentInset.left) * kForegroundBackgroundCellRatio, 0);
	_collectionViewFG.delegate = self;
	
	[self _updateHighlightImage];
}

- (void)_scrollView:(UIScrollView *)scrollView eventChangedWithCallbackType:(BSVideoTrimmerViewCallbackType)callbackType {
	if (!_isEffectModeUI) {
		if (scrollView == _collectionViewFG) {
			[self _contentOffsetFGDidChanged];
		} else {
			[self _contentOffsetBGDidChanged];
		}
		if (_isConfigurationFinish) {
			[self _informCallbackWithCallbackType:callbackType];
		}
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	_isChangingTimelineFrame = YES;
	_cursorViewLeadingConstraint.constant = 0;
	
	[self _scrollView:scrollView eventChangedWithCallbackType:BSVideoTrimmerViewCallbackTypeBegin];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	if (CGPointEqualToPoint(velocity, CGPointZero)) {
		[self _scrollView:scrollView eventChangedWithCallbackType:BSVideoTrimmerViewCallbackTypeEnd];
		_isChangingTimelineFrame = NO;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self _scrollView:scrollView eventChangedWithCallbackType:BSVideoTrimmerViewCallbackTypeOnProgress];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self _scrollView:scrollView eventChangedWithCallbackType:BSVideoTrimmerViewCallbackTypeEnd];
	_isChangingTimelineFrame = NO;
}

@end
