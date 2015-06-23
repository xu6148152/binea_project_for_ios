//
//  ZPBaseSystemActivity.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPBaseSystemActivity.h"

@implementation ZPBaseSystemActivity
{
	NSString *_text;
	UIImage *_image;
	NSURL *_url;
}

- (id)initWithPresentingViewController:(UIViewController *)viewController {
	if ((self = [super init])) {
		_presentingController = viewController;
	}
	return self;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	for (NSObject *item in activityItems) {
		if ([item isKindOfClass:[UIImage class]] || [item isKindOfClass:[NSString class]])
			return YES;
	}
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	for (NSObject *item in activityItems) {
		if ([item isKindOfClass:[UIImage class]])
			_image = (UIImage *)item;
		if ([item isKindOfClass:[NSString class]])
			_text = (NSString *)item;
		if ([item isKindOfClass:[NSURL class]])
			_url = (NSURL *)item;
	}
}

- (UIViewController *)activityViewController {
	return nil;
}

- (void)performActivity {
	void (^completionBlock) (void);

	completionBlock = ^{
		SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:self.serviceType];
		if (!composeVC) {
			[self activityDidFinish:NO];
			return;
		}

		composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
			[self activityDidFinish:YES];
		};
		if (_text)
			[composeVC setInitialText:_text];
		if (_image)
			[composeVC addImage:_image];
		if (_url)
			[composeVC addURL:_url];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"ZPActivityWillShowComposeView" object:nil];

		[self.presentingController presentViewController:composeVC animated:YES completion: ^{
		}];
	};

	if (self.presentingController.presentedViewController)
		[self.presentingController dismissViewControllerAnimated:YES completion:completionBlock];
	else
		completionBlock();
}

- (NSString *)serviceType {
	NSAssert(NO, @"overwrite is required for sub class");
	return nil;
}

@end
