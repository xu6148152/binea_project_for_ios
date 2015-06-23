//
//  ZPSharer.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Social/Social.h>
#import "ZPSharer.h"
#import "ZPFacebookActivity.h"
#import "ZPTwitterActivity.h"
#import "ZPInstagramActivity.h"
#import "ZPEvernoteActivity.h"
#import "ZPMacros.h"
#import "NSURL+CorrectPath.h"

@interface ZPSharer ()

@property (nonatomic, strong) UIPopoverController *popCtl;

@end


@implementation ZPSharer

+ (instancetype)sharedInstance {
	static ZPSharer *sharer = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharer = [[ZPSharer alloc] init];
	});
	return sharer;
}

- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_activityWillShowComposeView) name:@"ZPActivityWillShowComposeView" object:nil];
	}
	return self;
}

- (void)_activityWillShowComposeView {
	[[ZPSharer sharedInstance].popCtl dismissPopoverAnimated:YES];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSArray *)_shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView fromBarButtonItem:(UIBarButtonItem *)fromBarButtonItem additionalSharer:(ZPAdditionalSharer)additionalSharer completionHandler:(ZPSharerCompletionHandler)completionHandler {
	NSMutableArray *aryCustomActivities = [NSMutableArray array];
	if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
		[aryCustomActivities addObject:[[ZPFacebookActivity alloc] initWithPresentingViewController:presentingViewController]];
	}
	if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] || [ZPInstagramActivity isValidVideoWithPath:[url correctPath]]) {
		[aryCustomActivities addObject:[[ZPTwitterActivity alloc] initWithPresentingViewController:presentingViewController]];
	}
	if (additionalSharer & ZPAdditionalSharerInstagram) {
		ZPInstagramActivity *ig = [[ZPInstagramActivity alloc] init];
		ig.content = content;
		[aryCustomActivities addObject:ig];
	}
	if (additionalSharer & ZPAdditionalSharerEvernote) {
		ZPEvernoteActivity *evernote = [[ZPEvernoteActivity alloc] init];
		[aryCustomActivities addObject:evernote];
	}

	NSMutableArray *aryItems = [NSMutableArray array];
	if (image)
		[aryItems addObject:image];
	if (content)
		[aryItems addObject:content];
	if (url)
		[aryItems addObject:url];

	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:aryItems applicationActivities:aryCustomActivities];
	[activityVC setValue:subject forKey:@"subject"];
	activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop];
	activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
		if (activityType && !completed) {
			NSString *serviceType = nil;
			NSString *activityTitle = nil;
			for (ZPBaseSystemActivity *activity in aryCustomActivities) {
				if ([activity.activityType isEqualToString:activityType]) {
					serviceType = activity.serviceType;
					activityTitle = activity.activityTitle;
					break;
				}
			}

			BOOL canCreateSystemComposeVC = aryCustomActivities.count > 0 ? NO : YES;
			if (serviceType) {
				SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
				canCreateSystemComposeVC = composeVC != nil;
			}
			if (!canCreateSystemComposeVC && activityTitle) {
				[ZPSharer _showNoAccount:activityTitle];
			}
		}

		if (completionHandler) {
			completionHandler(activityType, completed);
		}
	};

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[ZPSharer sharedInstance].popCtl dismissPopoverAnimated:NO];
		[ZPSharer sharedInstance].popCtl = [[UIPopoverController alloc] initWithContentViewController:activityVC];
		if (fromView && fromView.window)
			[[ZPSharer sharedInstance].popCtl presentPopoverFromRect:fromView.frame inView:fromView.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		else if (fromBarButtonItem)
			[[ZPSharer sharedInstance].popCtl presentPopoverFromBarButtonItem:fromBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[presentingViewController presentViewController:activityVC animated:YES completion:nil];
	}
	return aryCustomActivities;
}

+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView additionalSharer:(ZPAdditionalSharer)additionalSharer completionHandler:(ZPSharerCompletionHandler)completionHandler {
	if (!presentingViewController || !fromView)
		return nil;

	return [self _shareImage:image subject:subject content:content url:url presentingViewController:presentingViewController fromView:fromView fromBarButtonItem:nil additionalSharer:additionalSharer completionHandler:completionHandler];
}

+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView completionHandler:(ZPSharerCompletionHandler)completionHandler {
	return [self shareImage:image subject:subject content:content url:url presentingViewController:presentingViewController fromView:fromView additionalSharer:ZPAdditionalSharerNone completionHandler:completionHandler];
}

+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromBarButtonItem:(UIBarButtonItem *)fromBarButtonItem additionalSharer:(ZPAdditionalSharer)additionalSharer completionHandler:(ZPSharerCompletionHandler)completionHandler {
	if (!presentingViewController || !fromBarButtonItem)
		return nil;

	return [self _shareImage:image subject:subject content:content url:url presentingViewController:presentingViewController fromView:nil fromBarButtonItem:fromBarButtonItem additionalSharer:additionalSharer completionHandler:completionHandler];
}

+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromBarButtonItem:(UIBarButtonItem *)fromBarButtonItem completionHandler:(ZPSharerCompletionHandler)completionHandler {
	return [self shareImage:image subject:subject content:content url:url presentingViewController:presentingViewController fromBarButtonItem:fromBarButtonItem additionalSharer:ZPAdditionalSharerNone completionHandler:completionHandler];
}

+ (void)_showNoAccount:(NSString *)activityTitle {
	NSString *title = [NSString stringWithFormat:@"No %@ Accounts", activityTitle];
	NSString *message = [NSString stringWithFormat:@"There are no %@ accounts configured. You can add or create a %@ account in Settings.", activityTitle, activityTitle];
	[[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:ZPLocalizedString(@"Done") otherButtonTitles:nil] show];
}

@end
