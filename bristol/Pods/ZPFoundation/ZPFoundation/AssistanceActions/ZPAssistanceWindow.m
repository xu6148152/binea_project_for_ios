//
//  ZPAssistanceWindow.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/16/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPAssistanceWindow.h"
#import "ZPAssistanceActionsManager.h"
#import "ZPAssistanceActionsViewController.h"
#import "UIView+Addition.h"
#import "ZPLog.h"

#define kStatusBarHeight 20

@interface ZPAssistanceWindow ()
{
	UIButton *_btnCancel;
	UIButton *_btnMore;
	UIButton *_btnTitle;
}
@property (nonatomic, assign) BOOL showMoreWindows;
@property (nonatomic, strong) UINavigationController *actionsViewController;
@property (nonatomic, strong) UIControl *modalView;

@end


@implementation ZPAssistanceWindow

- (id)init {
	if ((self = [super init])) {
		self.windowLevel = UIWindowLevelStatusBar + 1;
		self.backgroundColor = [UIColor colorWithRed:.2 green:.65 blue:0 alpha:1];

		_btnCancel = [self _createButtonWithAction:@selector(_btnCancelTapped) title:@"✗"];
		_btnMore = [self _createButtonWithAction:@selector(_btnMoreTapped) title:@"..."];

		NSObject <ZPAssistanceActionProtocol> *action = [ZPAssistanceActionsManager sharedInstance].defaultAction;
		_btnTitle = [self _createButtonWithAction:@selector(_btnTitleTapped) title:action.statusBarTitle];
		[self addSubview:_btnCancel];
		[self addSubview:_btnMore];
		[self addSubview:_btnTitle];

		[[ZPAssistanceActionsManager sharedInstance] defaultActionDidChangedCallback: ^{
		    NSObject <ZPAssistanceActionProtocol> *defaultAction = [ZPAssistanceActionsManager sharedInstance].defaultAction;
		    [_btnTitle setTitle:defaultAction.statusBarTitle forState:UIControlStateNormal];
		}];

		[self _rotateToStatusBarOrientation:[UIApplication sharedApplication].statusBarOrientation];
		[self _setHidden:YES animated:NO];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_motionDetectedNotification:) name:@"WindowMotionDetectedNotification" object:nil];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGSize size = self.bounds.size;
	_btnCancel.frame = CGRectMake(0, 0, 60, size.height);
	_btnMore.frame = CGRectMake(size.width - _btnCancel.width, 0, _btnCancel.width, size.height);
	_btnTitle.frame = CGRectMake(_btnCancel.right, 0, _btnMore.left - _btnCancel.right, size.height);
}

- (void)resignKeyWindow {
	[super resignKeyWindow];
}

- (void)makeKeyWindow {
	[super makeKeyWindow];
}

- (void)becomeKeyWindow {
	[super becomeKeyWindow];

	[_originalKeyWindow makeKeyWindow];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - motion -
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
		[self _setHidden:NO animated:YES];
	}
	else {
		[super motionEnded:motion withEvent:event];
	}
}

- (void)_motionDetectedNotification:(NSNotification *)notification {
	NSDictionary *dic = notification.userInfo;
	UIEventSubtype motion = [dic[@"EventSubtype"] integerValue];
	UIEvent *event = dic[@"Event"];

	if (event) {
		[self motionEnded:motion withEvent:event];
	}
}

#pragma mark - properties -
- (UINavigationController *)actionsViewController {
	if (!_actionsViewController) {
		ZPAssistanceActionsViewController *actionsVC = [[ZPAssistanceActionsViewController alloc] initWithStyle:UITableViewStylePlain];
		actionsVC.view.autoresizingMask = UIViewAutoresizingNone;

		_actionsViewController = [[UINavigationController alloc] initWithRootViewController:actionsVC];
		_actionsViewController.view.layer.cornerRadius = 4;
		_actionsViewController.view.clipsToBounds = YES;
		_actionsViewController.view.autoresizingMask = UIViewAutoresizingFlexibleAll;
	}
	return _actionsViewController;
}

- (UIControl *)modalView {
	if (!_modalView) {
		_modalView = [[UIControl alloc] init];
		_modalView.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
		_modalView.autoresizingMask = UIViewAutoresizingFlexibleAll;
		[_modalView addTarget:self action:@selector(_modalViewTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
	}
	return _modalView;
}

- (void)setShowMoreWindows:(BOOL)showMoreWindows {
	if (_showMoreWindows != showMoreWindows) {
		_showMoreWindows = showMoreWindows;

		UIView *viewToAddTo = [self _getViewAsAddTo];
		if (!viewToAddTo) {
			ZPLogError(@"viewToAddTo is nil");
			return;
		}
		CGRect topVCBounds = viewToAddTo.bounds;

		self.modalView.frame = CGRectMake(0, 0, topVCBounds.size.width, topVCBounds.size.height);
		self.modalView.alpha = showMoreWindows ? 0 : 1;
		[viewToAddTo addSubview:self.modalView];
		[viewToAddTo addSubview:self.actionsViewController.view];
		CGFloat width = kIsPhoneUI ? (topVCBounds.size.width - 60) : topVCBounds.size.width / 3;
		CGFloat height = kIsPhoneUI ? (topVCBounds.size.height / 2) : topVCBounds.size.height / 3;
		CGFloat topOfShown = [UIApplication sharedApplication].statusBarHidden ? 20 : 0;
		self.actionsViewController.view.frame = CGRectMake((topVCBounds.size.width - width) / 2, showMoreWindows ? -height : topOfShown, width, height);

		[UIView animateWithDuration:kDefaultAnimateDuration delay:0
		                    options:showMoreWindows ? UIViewAnimationOptionCurveEaseIn:UIViewAnimationOptionCurveEaseOut
		                 animations: ^{
		    self.modalView.alpha = showMoreWindows ? 1 : 0;
		    self.actionsViewController.view.top = showMoreWindows ? topOfShown : -height;
		} completion: ^(BOOL finished) {
		    if (!showMoreWindows) {
		        [self.modalView removeFromSuperview];
		        [self.actionsViewController.view removeFromSuperview];
			}
		}];
	}
}

- (void)_modalViewTouchUpInside {
	self.showMoreWindows = NO;
}

- (UIViewController *)_getRootViewController {
	UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
	return rootViewController;
}

- (UIViewController *)_getTopmostViewController {
	UIViewController *rootViewController = [self _getRootViewController];
	while (rootViewController.presentedViewController) {
		rootViewController = rootViewController.presentedViewController;
	}
	return rootViewController;
}

- (UIView *)_getOriginalWindow {
	CGRect bounds = [[UIScreen mainScreen] bounds];
	for (UIWindow *window in[UIApplication sharedApplication].windows) {
		CGRect boundsWin = window.bounds;
		if (CGRectEqualToRect(bounds, boundsWin)) {
			if (window.subviews.count > 0) {
				return window.subviews[0];
			}
			else {
				return window;
			}
		}
	}
	return [UIApplication sharedApplication].keyWindow;
}

- (UIView *)_getViewAsAddTo {
	UIView *addToView = [self _getOriginalWindow];
	if (!addToView) {
		UIViewController *topVC = [self _getTopmostViewController];
		addToView = topVC.view;
	}
	return addToView;
}

#pragma mark - actions
- (UIButton *)_createButtonWithAction:(SEL)action title:(NSString *)title {
	UIButton *btn = [[UIButton alloc] init];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:title forState:UIControlStateNormal];
	btn.titleLabel.adjustsFontSizeToFitWidth = YES;

	return btn;
}

- (BOOL)_isSelfHidden {
	return self.alpha == 0;
}

- (void)_setHidden:(BOOL)hidden animated:(BOOL)animated {
	if (!hidden)
		self.hidden = NO;
	[UIView animateWithDuration:animated ? kDefaultAnimateDuration:0 delay:0
	                    options:hidden ? UIViewAnimationOptionCurveEaseOut:UIViewAnimationOptionCurveEaseIn
	                 animations: ^{
	    self.alpha = hidden ? 0 : 1;
	} completion: ^(BOOL finished) {
	    self.hidden = hidden;
	}];
}

- (void)_btnMoreTapped {
	ZPLogDebug(@"_btnMoreTapped");
	self.showMoreWindows = !self.showMoreWindows;
	[self.actionsViewController popToRootViewControllerAnimated:NO];
}

- (void)_btnCancelTapped {
	ZPLogDebug(@"_btnCancelTapped");
	[self _setHidden:YES animated:YES];
	self.showMoreWindows = NO;
}

- (void)_btnTitleTapped {
	ZPLogDebug(@"_btnTitleTapped");

	NSObject <ZPAssistanceActionProtocol> *action = [ZPAssistanceActionsManager sharedInstance].defaultAction;
	if ([action conformsToProtocol:@protocol(ZPAssistanceSingleAction)]) {
		[(NSObject < ZPAssistanceSingleAction > *) action performAction];

		[self _setHidden:YES animated:YES];
	}
	else if ([action conformsToProtocol:@protocol(ZPAssistanceMultipleActions)]) {
		[(NSObject < ZPAssistanceMultipleActions > *) action performActionWithNavigationController : self.actionsViewController animated : YES];
		self.showMoreWindows = YES;
	}
}

#pragma mark - Rotation -
- (void)_willChangeStatusBarOrientationNotification:(NSNotification *)notification {
	NSNumber *value = [notification.userInfo valueForKey:UIApplicationStatusBarOrientationUserInfoKey];
	[self performSelector:@selector(_rotateToStatusBarOrientationNumber:) withObject:value afterDelay:0];
}

- (void)_rotateToStatusBarOrientationNumber:(NSNumber *)value {
	[self _rotateToStatusBarOrientation:[value intValue]];
}

- (void)_rotateToStatusBarOrientation:(UIInterfaceOrientation)orientation {
	UIScreen *screen = [UIScreen mainScreen];
	CGRect bounds = screen.bounds;
	if ([screen respondsToSelector:@selector(fixedCoordinateSpace)]) {
		bounds = [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace];
	}
	CGFloat screenWidth = bounds.size.width;
	CGFloat screenHeight = bounds.size.height;

	CGFloat pi = (CGFloat)M_PI;
	if (orientation == UIDeviceOrientationPortrait) {
		self.transform = CGAffineTransformIdentity;
		self.frame = CGRectMake(0.f, 0.f, screenWidth, kStatusBarHeight);
	}
	else if (orientation == UIDeviceOrientationLandscapeLeft) {
		self.transform = CGAffineTransformMakeRotation(pi * (90.f) / 180.0f);
		self.frame = CGRectMake(screenWidth - kStatusBarHeight, 0, kStatusBarHeight, screenHeight);
	}
	else if (orientation == UIDeviceOrientationLandscapeRight) {
		self.transform = CGAffineTransformMakeRotation(pi * (-90.f) / 180.0f);
		self.frame = CGRectMake(0.f, 0.f, kStatusBarHeight, screenHeight);
	}
	else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
		self.transform = CGAffineTransformMakeRotation(pi);
		self.frame = CGRectMake(0.f, screenHeight - kStatusBarHeight, screenWidth, kStatusBarHeight);
	}
}

#pragma mark - hitTest -
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self _isSelfHidden]) {
		return nil;
	}

	UIView *subViewTapped = nil;
	for (UIView *subView in self.subviews) {
		BOOL isInside = CGRectContainsPoint(subView.frame, point);
		if (isInside) {
			subViewTapped = subView;
			break;
		}
	}

	return subViewTapped;
}

@end
