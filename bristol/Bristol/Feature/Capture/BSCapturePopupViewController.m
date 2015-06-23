//
//  BSCapturePopupViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCapturePopupViewController.h"

#import "PureLayout.h"

#define kCapturePopupHasShownTimelineInstruction @"kCapturePopupHasShownTimelineInstruction"
#define kCapturePopupHasShownNOEffectInstruction @"kCapturePopupHasShownNOEffectInstruction"
#define kCapturePopupHasShownEffectInstruction @"kCapturePopupHasShownEffectInstruction"

@interface BSCapturePopupViewController ()

@property (weak, nonatomic) IBOutlet UIView *instructionView1;
@property (weak, nonatomic) IBOutlet UIView *instructionView2;
@property (weak, nonatomic) IBOutlet UIView *instructionViewHighlight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *imgViewIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewArrowLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewArrowTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewArrowHeightConstraint;

@property (nonatomic, strong) BSCapturePopupViewController *strongRef;
@property (nonatomic, copy) ZPVoidBlock timelineInstructionDidHideBlock;

@end

@implementation BSCapturePopupViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Capture" bundle:nil] instantiateViewControllerWithIdentifier:@"BSCapturePopupViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	
}

- (void)_showView1:(BOOL)view1 view2:(BOOL)view2 viewHighlight:(BOOL)viewHighlight {
	_instructionView1.hidden = !view1;
	_instructionView2.hidden = !view2;
	_instructionViewHighlight.hidden = !viewHighlight;
}

+ (BOOL)ifCanShowTimelineInstruction {
	return ![UserDefaults boolForKey:kCapturePopupHasShownTimelineInstruction];
}

+ (void)showTimelineInstructionWithCompletion:(ZPVoidBlock)completion {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	BSCapturePopupViewController *vc = [BSCapturePopupViewController instanceFromStoryboard];
	[window addSubview:vc.view];
	[vc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
	vc.view.alpha = 0;
	vc.strongRef = vc;
	vc.timelineInstructionDidHideBlock = completion;
	[vc _showView1:YES view2:NO viewHighlight:NO];
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		vc.view.alpha = 1;
	} completion:^(BOOL finished) {
	}];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:vc action:@selector(_tapped)];
	[vc.view addGestureRecognizer:tap];
	
	[UserDefaults setBool:YES forKey:kCapturePopupHasShownTimelineInstruction];
}

- (void)_tapped {
	if (!_instructionView1.hidden) {
		// view 1
		[self _showView1:NO view2:YES viewHighlight:NO];
	} else {
		// view 2
		self.view.userInteractionEnabled = NO;
		[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
			self.view.alpha = 0;
		} completion:^(BOOL finished) {
			[self.view removeFromSuperview];
			ZPInvokeBlock(_timelineInstructionDidHideBlock);
			_strongRef = nil;
		}];
	}
}

- (void)_showEffectInstructionWithIsEffect:(BOOL)isEffect arrowPointInWindowCoordinate:(CGPoint)arrowPoint {
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	[self view];
	[self _showView1:NO view2:NO viewHighlight:YES];
	
	if (isEffect) {
		_lblTitle.text = ZPLocalizedString(@"Pick your hero frame");
		_lblDescription.text = ZPLocalizedString(@"Sit back, relax, and enjoy the refreshed video built entirely around your hero frame.");
		_imgViewIcon.highlighted = YES;
	} else {
		_lblTitle.text = ZPLocalizedString(@"Your highlight point");
		_lblDescription.text = ZPLocalizedString(@"Magically, we have picked the potential most exciting moment in your highlight.");
		_imgViewIcon.highlighted = NO;
	}
	_imgViewArrowLeadingConstraint.constant = arrowPoint.x;
	_imgViewArrowTopConstraint.constant = -(window.height - arrowPoint.y - _instructionViewHighlight.height);
	_imgViewArrowHeightConstraint.constant = -_imgViewArrowTopConstraint.constant + 10;
	
	_strongRef = self;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnCloseTapped)];
	[self.view addGestureRecognizer:tap];
	
	[window addSubview:self.view];
	[self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
	self.view.alpha = 0;
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		self.view.alpha = 1;
	} completion:^(BOOL finished) {
	}];
}

+ (BOOL)ifCanShowNOEffectInstruction {
	return ![UserDefaults boolForKey:kCapturePopupHasShownNOEffectInstruction];
}

+ (void)showNOEffectInstructionWithArrowPointInWindowCoordinate:(CGPoint)arrowPoint {
	BSCapturePopupViewController *vc = [BSCapturePopupViewController instanceFromStoryboard];
	[vc _showEffectInstructionWithIsEffect:NO arrowPointInWindowCoordinate:arrowPoint];
	
	[UserDefaults setBool:YES forKey:kCapturePopupHasShownNOEffectInstruction];
}

+ (BOOL)ifCanShowEffectInstruction {
	return ![UserDefaults boolForKey:kCapturePopupHasShownEffectInstruction];
}

+ (void)showEffectInstructionWithArrowPointInWindowCoordinate:(CGPoint)arrowPoint {
	BSCapturePopupViewController *vc = [BSCapturePopupViewController instanceFromStoryboard];
	[vc _showEffectInstructionWithIsEffect:YES arrowPointInWindowCoordinate:arrowPoint];
	
	[UserDefaults setBool:YES forKey:kCapturePopupHasShownEffectInstruction];
}

- (IBAction)btnCloseTapped {
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		self.view.alpha = 0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
		_strongRef = nil;
	}];
}

@end
