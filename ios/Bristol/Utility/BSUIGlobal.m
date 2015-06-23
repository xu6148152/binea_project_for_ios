//
//  ZPUIGlobal.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/5/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "BSUIGlobal.h"
#import "BSAuthorizationViewController.h"
#import "BSAppDelegate.h"

#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>


BOOL darkHUD = NO;

@implementation BSUIGlobal

+ (void) setDarkHUD:(BOOL)dark {
	darkHUD = dark;
}

+ (UIWindow *)appWindow {
	return ((BSAppDelegate *)[UIApplication sharedApplication].delegate).appWindow;
}

+ (NSTimeInterval) durationForMessage:(NSString *)message {
	if (!message || message.length == 0) {
		return kDefaultHideHudDelay;
	}
	
	return MAX(1.4, 0.075 * message.length);
}

+ (MBProgressHUD *)showLoadingWithMessage:(NSString *)message {
	MBProgressHUD *hud = [MBProgressHUD HUDForView:[BSUIGlobal appWindow]];
	if (hud) {
		hud.mode = MBProgressHUDModeIndeterminate;
		hud.detailsLabelText = message;
	} else {
		hud = [BSUIGlobal createHUDMessage:message mode:MBProgressHUDModeIndeterminate];
	}
	hud.alpha = 0;
	[UIView animateWithDuration:0.2 animations:^{
		hud.alpha = darkHUD ? 0.8 : 0.6;
	}];
	return hud;
}

+ (void)hideLoading {
	MBProgressHUD *hud = [MBProgressHUD HUDForView:[BSUIGlobal appWindow]];
	
	if (hud) {
		[UIView animateWithDuration:0.4 animations:^{
			hud.alpha = 0;
		} completion:^(BOOL finished) {
			[hud hide:NO];
		}];
	}
}

+ (MBProgressHUD *)createHUDMessage:(NSString *)message mode:(MBProgressHUDMode)mode{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[BSUIGlobal appWindow]];
	hud.removeFromSuperViewOnHide = YES;
	hud.mode = mode;
	hud.detailsLabelText = message ? message : ZPLocalizedString(@"Waiting");
	hud.margin = 15;
	hud.cornerRadius = 0;
	hud.detailsLabelFont = [UIFont fontWithName:@"Avenir-MediumOblique" size:16];
	hud.minSize = CGSizeMake(250, 30);
	[[BSUIGlobal appWindow] addSubview:hud];
	[hud show:NO];
	
	return hud;
}

+ (void)showError:(NSError *)error {
	if (error && error.localizedDescription) {
		if ([error.domain isEqualToString:RKErrorDomain] && error.code == RKOperationCancelledError) {
			return;
		}
		if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
			return;
		}

		NSTimeInterval mininumInterval = kToastMininumInterval;
		if ([error.domain isEqualToString:AFNetworkingErrorDomain] || [error.domain isEqualToString:NSURLErrorDomain]) {
			mininumInterval = kErrorMininumInterval;
		}

		[BSUIGlobal showMessage:error.localizedDescription mininumInterval:mininumInterval];
	} else {
		[BSUIGlobal hideLoading];
	}
}

+ (void)showMessage:(NSString *)message {
	if (message && message.length > 0) {
		[BSUIGlobal showMessage:message mininumInterval:kToastMininumInterval];
	} else {
		[BSUIGlobal hideLoading];
	}
}

+ (void)showMessage:(NSString *)message mininumInterval:(NSTimeInterval)minimunInterval {
	static NSMutableDictionary *messageTimeDict;

	if (!messageTimeDict) {
		messageTimeDict = [[NSMutableDictionary alloc] init];
	}

	NSDate *lastDate = [messageTimeDict objectForKey:message];
	if (lastDate && [[NSDate date] timeIntervalSinceDate:lastDate] <= minimunInterval) {
		// if already a loading HUD, show the message (which replaces the loading indicator)
		MBProgressHUD *hud = [MBProgressHUD HUDForView:[BSUIGlobal appWindow]];
		if (!hud || hud.mode != MBProgressHUDModeIndeterminate) {
			return;
		}
	}

	[messageTimeDict setObject:[NSDate date] forKey:message];
	
	MBProgressHUD *hud = [MBProgressHUD HUDForView:[BSUIGlobal appWindow]];
	if (hud) {
		hud.mode = MBProgressHUDModeText;
		hud.detailsLabelText = message;
	} else {
		hud = [BSUIGlobal createHUDMessage:message mode:MBProgressHUDModeText];
	}
	
	hud.userInteractionEnabled = NO;
	hud.alpha = 0;
	hud.centerY = [BSUIGlobal appWindow].frame.size.height / 2 + 70;

	[UIView animateWithDuration:0.2 animations:^{
		hud.alpha = darkHUD ? 0.8 : 0.6;
		hud.centerY = [BSUIGlobal appWindow].frame.size.height / 2;
	} completion:^(BOOL finished) {
		if (finished) {

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([BSUIGlobal durationForMessage:message] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[UIView animateWithDuration:0.4 animations:^{
					hud.alpha = 0;
				} completion:^(BOOL finished) {
					if (finished) {
						[hud hide:NO];
					}
				}];
			});
		}
	}];
}

+ (void)showAlertMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(ZPVoidBlock)cancelHandler actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler {
	dispatch_main_async_safe(^ {
		[BSUIGlobal hideLoading];
		UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:nil message:message];
		[alert bk_setCancelButtonWithTitle:cancelTitle handler:cancelHandler];
		if (actionTitle) {
			[alert bk_addButtonWithTitle:actionTitle handler:actionHandler];
		}
		[alert show];
	});
}

+ (void)showAlertMessage:(NSString *)message actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler {
	[BSUIGlobal showAlertMessage:message cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:nil actionTitle:actionTitle actionHandler:actionHandler];
}

+ (void)showActionSheetTitle:(NSString *)title isDestructive:(BOOL)isDestructive actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler additionalConstruction:(void (^)(BSUIActionSheet *actionSheet))additionalConstruction {
	BSUIActionSheet *actionSheet = [BSUIActionSheet actionSheetWithTitle:title];
	[actionSheet addButtonWithTitle:ZPLocalizedString(@"Cancel") isDestructive:NO handler:nil];
	if (actionTitle && actionHandler) {
		[actionSheet addButtonWithTitle:actionTitle isDestructive:isDestructive handler:actionHandler];
	}
	ZPInvokeBlock(additionalConstruction, actionSheet);
	
	[actionSheet showInView:[BSUIGlobal appWindow]];
}

+ (void)showActionSheetTitle:(NSString *)title isDestructive:(BOOL)isDestructive actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler {
	[BSUIGlobal showActionSheetTitle:title isDestructive:isDestructive actionTitle:actionTitle actionHandler:actionHandler additionalConstruction:nil];
}

+ (void)showImagePickerControllerInViewController:(UIViewController *)viewController additionalConstruction:(void (^)(UIImagePickerController *picker))additionalConstruction didFinishPickingMedia:(void (^)(NSDictionary *info))didFinishPickingMedia didCancel:(ZPVoidBlock)didCancel {
	if (!viewController) {
		return;
	}
	
	BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.allowsEditing = YES;
	ZPInvokeBlock(additionalConstruction, imagePickerController);
	
    __weak UIImagePickerController *weakPicker = imagePickerController;
	ZPVoidBlock hideImagePickerController = ^ {
		[weakPicker dismissViewControllerAnimated:YES completion:NULL];
		if (statusBarHidden) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
			});
		}
	};
	
	imagePickerController.bk_didCancelBlock = ^(UIImagePickerController *picker) {
		ZPInvokeBlock(hideImagePickerController);
		ZPInvokeBlock(didCancel);
	};
	imagePickerController.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *meta) {
		ZPInvokeBlock(hideImagePickerController);
		ZPInvokeBlock(didFinishPickingMedia, meta);
	};
	
	[viewController presentViewController:imagePickerController animated:YES completion:^{
		ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
		if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
			BSAuthorizationViewController *vc = [BSAuthorizationViewController instanceFromDefaultNibWithType:BSAuthorizationTypePhotos];
			[vc showInViewController:imagePickerController dismissCompletion:nil];
		}
	}];
}

+ (UILabel *)createCommonTableViewSectionHeaderWithTitle:(NSString *)title {
	UILabel *label = [[UILabel alloc] init];
	label.text = [NSString stringWithFormat:@"    %@", title];
	label.font = [UIFont fontWithName:@"Avenir-HeavyOblique" size:14];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor colorWithRed:.89 green:.89 blue:.89 alpha:.96];
	
	return label;
}

#pragma mark - colors

+ (UIColor *)alertColor {
	return [UIColor colorWithRed:0.9216 green:0.2784 blue:0.2784 alpha:1.0];
}

+ (UIColor *)placeholderColor {
	return [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0];
}

+ (UIColor *)positiveColor {
	return [UIColor colorWithRed:0.7804 green:0.8863 blue:0 alpha:1.0];
}

+ (UIColor *)negativeColor {
	return [UIColor colorWithRed:0.8431 green:0.2431 blue:0.1137 alpha:1.0];
}

+ (UIColor *)multiplyBlendColor {
	return [UIColor colorWithRed:.73 green:.87 blue:.04 alpha:1];
}

+ (UIColor *)appBGColor {
	return [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1];
}

+ (UIColor *)tableViewCellColor {
	return [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
}

+ (UIImage *)placeholderImage {
	return [UIImage imageNamed:@"common_placeholder_bg"];
}

@end
