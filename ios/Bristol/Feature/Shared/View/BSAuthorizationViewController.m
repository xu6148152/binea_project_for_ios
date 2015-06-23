//
//  BSAuthorizationViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/23/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAuthorizationViewController.h"
#import "PureLayout.h"

@interface BSAuthorizationViewController()

@property (assign, nonatomic) BSAuthorizationType type;
@property (copy, nonatomic) ZPVoidBlock dismissCompletion;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIView *modalView;

@end



@implementation BSAuthorizationViewController

+ (instancetype)instanceFromDefaultNibWithType:(BSAuthorizationType)type {
	BSAuthorizationViewController *viewController = [[BSAuthorizationViewController alloc] initWithNibName:@"BSAuthorizationViewController" bundle:nil];
	[viewController.view autoSetDimensionsToSize:CGSizeMake(250, 250)];
	viewController.type = type;
	return viewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (void)setType:(BSAuthorizationType)type {
	_type = type;
	
	NSString *iconName, *desc;
	switch (_type) {
  		case BSAuthorizationTypeCamera:
			iconName = @"common_popup_accesscamera";
			desc = ZPLocalizedString(@"Authorization Request of Camera");
			break;
		case BSAuthorizationTypePhotos:
			iconName = @"common_popup_accessphotos";
			desc = ZPLocalizedString(@"Authorization Request of Photos");
			break;
		case BSAuthorizationTypeMicrophone:
			iconName = @"common_popup_accessmicrophone";
			desc = ZPLocalizedString(@"Authorization Request of Microphone");
			break;
		case BSAuthorizationTypeLocation:
			iconName = @"common_popup_accesslocation";
			desc = ZPLocalizedString(@"Authorization Request of Location");
			break;
	}
	_imgViewIcon.image = [UIImage imageNamed:iconName];
	_lblDesc.text = desc;
}

- (void)_dismissWithIsCancel:(BOOL)isCancel {
	if (_modalView.superview) {
		[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
			_modalView.alpha = 0;
		} completion:^(BOOL finished) {
			[_modalView removeFromSuperview];
			[self removeFromParentViewController];
			
			if (!isCancel) {
				[BSUtility openSettingsApp];
			}
			ZPInvokeBlock(_dismissCompletion);
		}];
	} else {
		if (!isCancel) {
			[BSUtility openSettingsApp];
		}
		ZPInvokeBlock(_dismissCompletion);
	}
}

- (IBAction)btnAllowAccessTapped:(id)sender {
	[self _dismissWithIsCancel:NO];
}

- (IBAction)modalViewTapped:(UITapGestureRecognizer *)sender {
	CGPoint location = [sender locationInView:_modalView];
	if (!CGRectContainsPoint(self.view.frame, location)) {
		[self _dismissWithIsCancel:YES];
	}
}

- (void)showInViewController:(UIViewController *)viewController dismissCompletion:(ZPVoidBlock)dismissCompletion {
	if (viewController) {
		_dismissCompletion = [dismissCompletion copy];
		[viewController addChildViewController:self];
		
		_modalView.alpha = 0;
		[viewController.view addSubview:_modalView];
		[_modalView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
		
		[_modalView addSubview:self.view];
		[self.view autoCenterInSuperview];
		
		[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
			_modalView.alpha = 1;
		}];
	}
}

@end
