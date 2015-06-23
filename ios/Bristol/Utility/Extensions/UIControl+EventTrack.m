//
//  UIButton+EventName.m
//  Bristol
//
//  Created by Yangfan Huang on 5/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UIControl+EventTrack.h"
#import "BSEventTracker.h"
#import <objc/runtime.h>

static char kEventTrackNameKey;
static char kEventTrackPropertiesKey;

@interface BSEventTrackPropertyHelper : NSObject
+ (void) setEventTrackName:(NSString *)eventTrackName forObject:(id)object;
+ (NSString *) eventTrackNameForObject:(id)object;
+ (void) setEventTrackProperties:(NSDictionary *)eventTrackProperties forObject:(id)object;
+ (NSDictionary *) eventTrackPropertiesForObject:(id)object;
@end

@implementation BSEventTrackPropertyHelper
+ (void) setEventTrackName:(NSString *)eventTrackName forObject:(id)object {
	[object willChangeValueForKey:@"eventTrackName"];
	objc_setAssociatedObject(object, &kEventTrackNameKey, eventTrackName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[object didChangeValueForKey:@"eventTrackName"];
}

+ (NSString *) eventTrackNameForObject:(id)object {
	return objc_getAssociatedObject(object, &kEventTrackNameKey);
}

+ (void) setEventTrackProperties:(NSDictionary *)eventTrackProperties forObject:(id)object {
	[object willChangeValueForKey:@"eventTrackProperties"];
	objc_setAssociatedObject(object, &kEventTrackPropertiesKey, eventTrackProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[object didChangeValueForKey:@"eventTrackProperties"];
}

+ (NSDictionary *) eventTrackPropertiesForObject:(id)object {
	return objc_getAssociatedObject(object, &kEventTrackPropertiesKey);
}
@end


@implementation UIControl (EventTrack)
- (void) setEventTrackName:(NSString *)eventTrackName {
	[BSEventTrackPropertyHelper setEventTrackName:eventTrackName forObject:self];
}

- (NSString *) eventTrackName {
	return [BSEventTrackPropertyHelper eventTrackNameForObject:self];
}

- (void) setEventTrackProperties:(NSDictionary *)eventTrackProperties {
	[BSEventTrackPropertyHelper setEventTrackProperties:eventTrackProperties forObject:self];
}

- (NSDictionary *) eventTrackProperties {
	return [BSEventTrackPropertyHelper eventTrackPropertiesForObject:self];
}

- (void) trackTap {
	[BSEventTracker trackControl:self properties:nil];
}
@end


@implementation UIBarButtonItem (EventTrack)
- (void) setEventTrackName:(NSString *)eventTrackName {
	[BSEventTrackPropertyHelper setEventTrackName:eventTrackName forObject:self];
}

- (NSString *) eventTrackName {
	return [BSEventTrackPropertyHelper eventTrackNameForObject:self];
}

- (void) setEventTrackProperties:(NSDictionary *)eventTrackProperties {
	[BSEventTrackPropertyHelper setEventTrackProperties:eventTrackProperties forObject:self];
}

- (NSDictionary *) eventTrackProperties {
	return [BSEventTrackPropertyHelper eventTrackPropertiesForObject:self];
}

- (void) trackTap {
	[BSEventTracker trackBarButtonItem:self properties:nil];
}

@end