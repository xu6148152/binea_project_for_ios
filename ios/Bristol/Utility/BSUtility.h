//
//  BSUtility.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMedia/CoreMedia.h>

static inline CGFloat timeWithFrame(CGFloat frame) {
	return frame / kRenderedVideoFrameRate;
}

static inline CMTime cmTimeWithSeconds(Float64 sec) {
	if (sec < 0) {
		return kCMTimeZero;
	} else {
		return CMTimeMakeWithSeconds(sec, NSEC_PER_SEC);
	}
}


@interface BSUtility : NSObject

+ (UIViewController *)getTopmostViewController;
+ (void)pushViewController:(UIViewController *)vc;

+ (NSString *)timesAgoOfDate:(NSDate *)date;
+ (NSString *)distanceBetweenLocation1:(CLLocationCoordinate2D)location1 location2:(CLLocationCoordinate2D)location2;
+ (NSString *)formatValue:(unsigned long long)value;
+ (NSString *)formatSportsId:(NSSet *)sports;

+ (void)openSettingsApp;
+ (NSString *)appNameLocalized;

+ (NSDate *)getPopUpFirstActionDate:(NSString *)key;
+ (void)savePopUpFirstActionDate:(NSDate *)date withKey:(NSString *)key;

+ (NSString *)MD5:(NSString *)string;

@end
