//
//  BSMainViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMainViewController.h"
#import "BSFeedViewController.h"
#import "BSToptenViewController.h"
#import "BSCaptureViewController.h"
#import "BSExploreViewController.h"
#import "BSProfileViewController.h"
#import "BSAccountLoginViewController.h"
#import "BSAccountGetStartedViewController.h"

#import "BSDataManager.h"
#import "BSEventTracker.h"

@interface BSMainViewController () <UITabBarControllerDelegate>
{
}

@end

@implementation BSMainViewController
+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BSMainViewController"];
}

- (void)_checkIfNeedToLoadTabViewControllers {
	NSArray *aryVC = self.viewControllers;
	NSAssert(aryVC.count == 5, @"tab bar setup error");
	if (((UINavigationController *)aryVC[0]).viewControllers.count == 0) {
		[((UINavigationController *)aryVC[0]) setViewControllers:@[[BSFeedViewController instanceFromStoryboard]]];
		[((UINavigationController *)aryVC[1]) setViewControllers:@[[BSTopTenViewController instanceFromStoryboard]]];
		[((UINavigationController *)aryVC[3]) setViewControllers:@[[BSExploreViewController instanceFromStoryboard]]];
		[((UINavigationController *)aryVC[4]) setViewControllers:@[[BSProfileViewController instanceFromStoryboard]]];
		
		for (UITabBarItem *item in self.tabBar.items) {
			item.title = nil;
			
			int offset = 6;
			item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
			item.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
		}
	}
}

- (void)_showLoginView {
	if (!self.view.window) {
		self.tabBar.hidden = YES;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self _showLoginView];
		});
	} else {
		[self presentViewController:[BSAccountGetStartedViewController instanceNavigationControllerFromStoryboard] animated:NO completion:^{
			self.tabBar.hidden = NO;
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.delegate = self;
	
	if ([BSDataManager sharedInstance].currentUser) {
		[self _checkIfNeedToLoadTabViewControllers];
	} else {
		[self _showLoginView];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_checkIfNeedToLoadTabViewControllers) name:kDidSetCurrentUserNotification object:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSString *eventName;
	
	switch ([[tabBarController viewControllers] indexOfObject:viewController]) {
		case 0:
			eventName = @"feed_tab";
			break;
		case 1:
			eventName = @"top10_tab";
			break;
		case 2:
			[BSEventTracker trackTap:@"capture_tab" page:nil properties:nil];
			[self presentViewController:[BSCaptureViewController instanceNavigationControllerFromStoryboard] animated:YES completion:NULL];
			return NO;
		case 3:
			eventName = @"explore_tab";
			break;
		case 4:
			eventName = @"profile_tab";
			break;
	}
	
	if (eventName) {
		[BSEventTracker trackTap:eventName page:nil properties:nil];
	}
	UIViewController *targetViewController = ((UINavigationController *)viewController).viewControllers[0];
	if (targetViewController.isViewLoaded) {
		[BSEventTracker trackPageView:(id<BSEventTrackPageProtocol>)targetViewController];
	}

	return YES;
}

@end
