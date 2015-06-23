//
//  BSEventTracker.h
//  Bristol
//
//  Created by Yangfan Huang on 5/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUserMO.h"

@protocol BSEventTrackPageProtocol <NSObject>
@property (nonatomic) NSString *useCase;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSDictionary *pageViewProperties;
@end

@interface BSEventTracker : NSObject
+ (void) initializeTracker;

+ (void) setUser:(BSUserMO *)user;
+ (void) increaseUserProperty:(NSString *)property by:(NSNumber *)amount;
+ (void) setUserProperties:(NSDictionary *)properties;
+ (void) setUserPropertiesOnce:(NSDictionary *)properties;

+ (void) setSuperProperties:(NSDictionary *)properties;

// for automatically tap tracking
+ (void) trackControl:(UIControl *)control properties:(NSDictionary *)properties;
+ (void) trackBarButtonItem:(UIBarButtonItem *)barButtonItem properties:(NSDictionary *)properties;

+ (void) trackPageView:(id<BSEventTrackPageProtocol>)page;
+ (void) trackGuideView:(NSString *)guideName page:(id<BSEventTrackPageProtocol>)page;
+ (void) trackResult:(BOOL)success eventName:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties;

+ (void) trackTap:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties;
+ (void) trackAction:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties;
+ (void) trackGenericEvent:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties;

@end

// Priority of properties, from high to low:

// function parameters
// properties set on UIControl
// properties set on view controller (page)