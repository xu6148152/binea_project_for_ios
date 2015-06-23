//
//  ZPSharer.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZPSharerCompletionHandler)(NSString *activityType, BOOL completed);
typedef NS_ENUM (NSUInteger, ZPAdditionalSharer) {
	ZPAdditionalSharerNone = 0,
	ZPAdditionalSharerInstagram = 1 << 0,
	    ZPAdditionalSharerEvernote  = 1 << 1,
};

@interface ZPSharer : NSObject

// @return activities to be shown
+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView completionHandler:(ZPSharerCompletionHandler)completionHandler;
+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromView:(UIView *)fromView additionalSharer:(ZPAdditionalSharer)additionalSharer completionHandler:(ZPSharerCompletionHandler)completionHandler;

+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromBarButtonItem:(UIBarButtonItem *)fromBarButtonItem completionHandler:(ZPSharerCompletionHandler)completionHandler;
+ (NSArray *)shareImage:(UIImage *)image subject:(NSString *)subject content:(NSString *)content url:(NSURL *)url presentingViewController:(UIViewController *)presentingViewController fromBarButtonItem:(UIBarButtonItem *)fromBarButtonItem additionalSharer:(ZPAdditionalSharer)additionalSharer completionHandler:(ZPSharerCompletionHandler)completionHandler;

@end
