//
//  BSEventTracker.m
//  Bristol
//
//  Created by Yangfan Huang on 5/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventTracker.h"
#import "BSUtility.h"
#import "UIControl+EventTrack.h"
#import "BSBaseViewController.h"

#import <Mixpanel/Mixpanel.h>

NSDateFormatter *UTCDateFormatter;


#define kEventTrackTypeTap @"tap"
#define kEventTrackTypePageView @"pageview"
#define kEventTrackTypeGuideView @"guideview"
#define kEventTrackTypeSuccess @"success"
#define kEventTrackTypeFailure @"failure"

#define kEventTrackTypeAction @"action"
#define kEventTrackTypeGeneric @"event"

@implementation BSEventTracker
+ (void) initializeTracker {
//#if !(TARGET_IPHONE_SIMULATOR)
	// TODO: this is the test app token. Replace it with production token.
	[Mixpanel sharedInstanceWithToken:@"6e9107abaa7beeddd0cbf7514ea994c4"];
//#endif
}

+ (void) setUser:(BSUserMO *)user {
	if (user && user.email) {
		Mixpanel *mixpanel = [Mixpanel sharedInstance];
		NSString *md5 = [BSUtility MD5:user.email];
		
		if (![md5 isEqualToString:mixpanel.distinctId]) {
			[mixpanel createAlias:md5 forDistinctID:mixpanel.distinctId];
			[mixpanel identify:md5];
		}
		
		if (!UTCDateFormatter) {
			UTCDateFormatter = [[NSDateFormatter alloc] init];
			[UTCDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
			[UTCDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
			[UTCDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
		}
		
		[self setUserPropertiesOnce:@{@"$created":[UTCDateFormatter stringFromDate:[NSDate date]]}];
		
		if (user.name_human_readable) {
			[self setUserProperties:@{@"name":user.name_human_readable}];
		}
		
		NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithObject:user.email forKey:@"$email"];
		if (user.name_id)
			properties[@"username"] = user.name_id;
		if (user.identifier)
			properties[@"sid"] = user.identifier;
		[self setUserProperties:properties];
	} else {
		[[Mixpanel sharedInstance] identify:[[NSUUID UUID] UUIDString]];
	}
}

+ (void) increaseUserProperty:(NSString *)property by:(NSNumber *)amount {
	[[Mixpanel sharedInstance].people increment:property by:amount];
}

+ (void) setUserProperties:(NSDictionary *)properties {
	[[Mixpanel sharedInstance].people set:properties];
}

+ (void) setUserPropertiesOnce:(NSDictionary *)properties {
	[[Mixpanel sharedInstance].people setOnce:properties];
}

+ (void) setSuperProperties:(NSDictionary *)properties {
	[[Mixpanel sharedInstance] registerSuperProperties:properties];
}

+ (NSMutableDictionary *) mutablePropertiesFromPage:(id<BSEventTrackPageProtocol>)page {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	if (!page) {
		UIViewController *topViewController = [BSUtility getTopmostViewController];
		if (topViewController && [topViewController conformsToProtocol:@protocol(BSEventTrackPageProtocol)]) {
			page = (id<BSEventTrackPageProtocol>)topViewController;
		}
	}
	
	if (page) {
		if (page.pageName) {
			[dict setObject:page.pageName forKey:@"pagename"];
		}
		if (page.useCase) {
			[dict setObject:page.useCase forKey:@"usecase"];
		}
	}
	
	return dict;
}

+ (void) trackControl:(UIControl *)control properties:(NSDictionary *)properties {
	if (control.eventTrackName) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:control.eventTrackProperties];
		[dict setValuesForKeysWithDictionary:properties];
		[self trackEventType:kEventTrackTypeTap eventName:control.eventTrackName page:nil properties:dict];
	}
}

+ (void) trackBarButtonItem:(UIBarButtonItem *)barButtonItem properties:(NSDictionary *)properties {
	if (barButtonItem.eventTrackName) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:barButtonItem.eventTrackProperties];
		[dict setValuesForKeysWithDictionary:properties];
		[self trackEventType:kEventTrackTypeTap eventName:barButtonItem.eventTrackName page:nil properties:dict];
	}
}

+ (void) trackTap:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties {
	[self trackEventType:kEventTrackTypeTap eventName:eventName page:page properties:properties];
}

+ (void) trackResult:(BOOL)success eventName:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties {
	[self trackEventType:success ? kEventTrackTypeSuccess : kEventTrackTypeFailure eventName:eventName page:page properties:properties];
}

+ (void) trackPageView:(id<BSEventTrackPageProtocol>)page {
	if (page.pageName) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:page.pageViewProperties];
		if (page.useCase) {
			[dict setObject:page.useCase forKey:@"usecase"];
		}
		[[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@.%@", kEventTrackTypePageView, page.pageName] properties:dict];
	}
}

+ (void) trackGuideView:(NSString *)guideName page:(id<BSEventTrackPageProtocol>)page {
	[self trackEventType:kEventTrackTypeGuideView eventName:guideName page:page properties:nil];
}

+ (void) trackAction:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties {
	[self trackEventType:kEventTrackTypeAction eventName:eventName page:page properties:properties];
}

+ (void) trackGenericEvent:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties {
	[self trackEventType:kEventTrackTypeGeneric eventName:eventName page:page properties:properties];
}

+ (void) trackEventType:(NSString *)eventType eventName:(NSString *)eventName page:(id<BSEventTrackPageProtocol>)page properties:(NSDictionary *)properties {
	if (eventName) {
		NSMutableDictionary *dict = [self mutablePropertiesFromPage:page];
		[dict setValuesForKeysWithDictionary:properties];
		[[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"%@.%@", eventType, eventName] properties:dict];
	}
}
@end
