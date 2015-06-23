//
//  ZPBaseViewController.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/3/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@implementation UIViewController (InstanceFromStoryboard)

+ (instancetype)instanceFromStoryboard {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

- (void)adjustScrollViewInsets:(UIScrollView *)scrollView {
	CGFloat tabBarHeight = self.tabBarController.tabBar.height;
	[scrollView setContentInset:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
	[scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
}

@end


@implementation BSBaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[BSEventTracker trackPageView:self];
	
	self.view.backgroundColor = [BSUIGlobal appBGColor];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[BSUIGlobal setDarkHUD:NO];
}

- (BOOL)hidesBottomBarWhenPushed {
	return (self.navigationController.topViewController == self);
}

@end


@implementation BSBaseTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[BSEventTracker trackPageView:self];

	self.view.backgroundColor = [BSUIGlobal appBGColor];

	[self.tableView setGlobalUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[BSUIGlobal setDarkHUD:NO];
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (BOOL)hidesBottomBarWhenPushed {
	return (self.navigationController.topViewController == self);
}

@end



@implementation BSTabbarBaseViewController
{
//	id _interactivePopGestureRecognizerDelegate;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[BSEventTracker trackPageView:self];
	
	self.view.backgroundColor = [BSUIGlobal appBGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[BSUIGlobal setDarkHUD:NO];
    BOOL hidden = self.navigationController.viewControllers.count == 1;
	[self.navigationController setNavigationBarHidden:hidden animated:YES];
	
//	_interactivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
//	self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count != 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
	}
	
//	self.navigationController.interactivePopGestureRecognizer.delegate = _interactivePopGestureRecognizerDelegate;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.rootViewController != self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if(self.navigationController.viewControllers.count > 1){
		return YES;
	}
	return NO;
}

- (void)dealloc {
//	self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end


@implementation BSTabbarBaseTableViewController
{
//	id _interactivePopGestureRecognizerDelegate;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[BSEventTracker trackPageView:self];
	
	self.view.backgroundColor = [BSUIGlobal appBGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[BSUIGlobal setDarkHUD:NO];

    BOOL hidden = self.navigationController.viewControllers.count == 1;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
	
//	_interactivePopGestureRecognizerDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
//	self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count != 1) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
	}
	
//	self.navigationController.interactivePopGestureRecognizer.delegate = _interactivePopGestureRecognizerDelegate;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.rootViewController != self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if(self.navigationController.viewControllers.count > 1){
		return YES;
	}
	return NO;
}

- (void)dealloc {
//	self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end
