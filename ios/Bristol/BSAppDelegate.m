//
//  ZPAppDelegate.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/3/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "BSAppDelegate.h"
#import "BSDataManager.h"
#import "BSHttpResponseDataModel.h"
#import "UIImage+Resize.h"
#import "BSRKDateTransformer.h"
#import "BSEventTracker.h"

#import "BSMainViewController.h"

#import "SoundManager.h"
#import <Fabric/Fabric.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <RestKit/RestKit.h>

#ifdef DEBUG
#import "BSAssistanceActionHeapInspector.h"
#endif

@implementation BSAppDelegate

- (void)_setupDebugLog {
#if defined(DEBUG) && (defined(guichao_huang_gary) || defined(gary_wong))
	ZPLogConfigureByName("*", ZPLogLevelDebug);
	ZPLogConfigureByComponent(lcl_cVideo, ZPLogLevelDebug);

	RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
	RKLogConfigureByName("RestKit/CoreData", RKLogLevelOff);
	RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);

#elif defined(DEBUG) && defined(bo)
    ZPLogConfigureByName("*", ZPLogLevelDebug);
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelOff);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
#elif defined(DEBUG)
	ZPLogConfigureByName("*", ZPLogLevelError);
#else

#endif
}

void _uncaughtExceptionHandler(NSException *exception) {
    [[BSDataManager sharedInstance] save];
}

- (void)_setupCrashReporter {
	[[Twitter sharedInstance] startWithConsumerKey:@"ImmsPBCeRycYBv4a3YqYll5Oj" consumerSecret:@"n4Bv5EY3lJEVvG9mFRrpFPIq34GPEDQccT18bTbcwvdPrgDPSl"];
    [Fabric with:@[CrashlyticsKit, TwitterKit]];
	NSSetUncaughtExceptionHandler(&_uncaughtExceptionHandler);
}

- (void)_logoutCurrentUser {
	[[BSDataManager sharedInstance] logOut];
	_appWindow.rootViewController = [BSMainViewController instanceFromStoryboard];
}

- (void)_setupData {
	[[SoundManager sharedManager] setAllowsBackgroundMusic:YES];
	
    [ZPApiUrlManager initializeWithApiUrls:@[@"https://bristol-test.zepp.com/api/b1"] currentApiUrlIndex:0];
	[BSDataManager sharedInstance];
	
	// custom date transformer from milli-seconds to NSDate
	[[RKValueTransformer defaultValueTransformer] insertValueTransformer:[BSRKDateTransformer timeIntervalInMilliSecondSince1970ToDateValueTransformer] atIndex:0];
	
	[SDWebImageDownloader sharedDownloader].shouldDecompressImages = NO;
	[SDImageCache sharedImageCache].shouldDecompressImages = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_logoutCurrentUser) name:kUserDidLogoutNotification object:nil];
}

- (void)_setupApperance {
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	
    [[UINavigationBar appearance] setHeight:48];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-4 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica-BoldOblique" size:17], NSForegroundColorAttributeName:[UIColor blackColor] }];
    
    UIImage *backButtonBackgroundImage = [UIImage imageNamed:@"common_topnav_back"];
    backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(INFINITY, 0) forBarMetrics:UIBarMetricsDefault];
}

- (id)init {
	self = [super init];
	if (self) {
		CGRect frame = [UIScreen mainScreen].bounds;
#ifdef DEBUG
		[[ZPAssistanceActionsManager sharedInstance] addAction:[BSAssistanceActionHeapInspector new]];
		_window = [[ZPMotionDetectWindow alloc] initWithFrame:frame];
#else
		_window = [[UIWindow alloc] initWithFrame:frame];
#endif
	}
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[BSEventTracker initializeTracker];

	[self _setupCrashReporter];
    [self _setupDebugLog];
    [self _setupData];
    [self _setupApperance];
	
	self.appWindow = self.window;
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[BSEventTracker trackAction:@"app_open" page:nil properties:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
