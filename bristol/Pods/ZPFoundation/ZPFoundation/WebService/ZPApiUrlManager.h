//
//  ZPApiUrlManager.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *ZPApiUrlDidChangedNotification = @"ZPApiUrlDidChangedNotification";

@interface ZPApiUrlManager : NSObject

+ (void)initializeWithApiUrls:(NSArray *)allApiUrls currentApiUrlIndex:(NSUInteger)index;
+ (instancetype)sharedInstance;

- (NSArray *)allApiUrls; // array of NSString objects
- (NSURL *)currentApiUrl;
- (NSString *)currentApiUrlString;

- (void)setCurrentApiUrlAtIndex:(NSUInteger)index;
- (BOOL)isReleaseModeForUrlString:(NSString *)urlString;

@end
