//
//  BSUtility.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUtility.h"
#import "BSSportMO.h"
#import "BSDataManager.h"
#import "UIImage+Resize.h"

#import "BSUIGlobal.h"

#import "NSDate+TimeAgo.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BSUtility

+ (UIViewController *)getTopmostViewController
{
    UIViewController *rootViewController = [BSUIGlobal appWindow].rootViewController;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
	
	while (YES) {
		if ([rootViewController isKindOfClass:[UINavigationController class]] && ((UINavigationController *)rootViewController).topViewController) {
			rootViewController = ((UINavigationController *)rootViewController).topViewController;
		} else if (!rootViewController.presentedViewController) {
			return rootViewController;
		}
		
		while (rootViewController.presentedViewController) {
			rootViewController = rootViewController.presentedViewController;
		}
	}
}

+ (void)pushViewController:(UIViewController *)vc {
    if (!vc) {
        return;
    }
    
    UIViewController *topmostViewController = [self getTopmostViewController];
	if (topmostViewController.navigationController) {
		[topmostViewController.navigationController pushViewController:vc animated:YES];
	}
	else {
		[topmostViewController presentViewController:vc animated:YES completion:NULL];
	}
}

+ (NSString *)timesAgoOfDate:(NSDate *)date{
    return [date timeAgoSimple];
}

+ (NSString *)distanceBetweenLocation1:(CLLocationCoordinate2D)location1 location2:(CLLocationCoordinate2D)location2 {
	if (!CLLocationCoordinate2DIsValid(location1) || !CLLocationCoordinate2DIsValid(location2)) {
		return @"-";
	}
	
	CLLocationDistance distance = [[[CLLocation alloc] initWithLatitude:location1.latitude longitude:location1.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:location2.latitude longitude:location2.longitude]];
	static NSNumberFormatter *numberFormatter;
	if (!numberFormatter) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		numberFormatter.numberStyle = NSNumberFormatterNoStyle;
	}
	
	NSLengthFormatter *formatter = [[NSLengthFormatter alloc] init];
	formatter.numberFormatter = numberFormatter;
	return [formatter stringFromMeters:distance];
}

// http://stackoverflow.com/questions/11993806/convert-int-to-shortened-formatted-string
// http://nshipster.com/nsformatter/
+ (NSString *)formatValue:(unsigned long long)value {
	NSUInteger index = 0;
	double dvalue = (double)value;
	//Updated to use correct SI Symbol ( http://en.wikipedia.org/wiki/SI_prefix )
	NSArray *suffix = @[ @"", @"k", @"M", @"G", @"T", @"P", @"E" ];
	
	while ((value/=1000) && ++index) dvalue /= 1000;
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	//Germany Example
	[formatter setLocale:[NSLocale currentLocale]];
	//Set fractional digits to 0 or 1
	[formatter setMaximumFractionDigits:(int)(dvalue < 100.0 && ((unsigned)((dvalue - (unsigned)dvalue) * 10) > 0))];
	
	NSString *valueFormatted = [[formatter stringFromNumber:[NSNumber numberWithFloat:dvalue]]
						stringByAppendingString:[suffix objectAtIndex:index]];
	
	return valueFormatted;
}

+ (NSString *)formatSportsId:(NSSet *)sports {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (BSSportMO *sport in sports) {
		if ([sport isKindOfClass:[BSSportMO class]]) {
			[array addObject:sport.identifier];
		}
	}
	return [array componentsJoinedByString:@","];
}

+ (void)openSettingsApp {
    if (&UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

+ (NSString *)appNameLocalized {
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	if ([appName length] == 0) {
		appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
	}
	
	return appName;
}

+ (NSDate *)getPopUpFirstActionDate:(NSString *)key {
    NSData *dateData = [UserDefaults objectForKey:key];
    NSMutableDictionary *dateDic = [NSKeyedUnarchiver unarchiveObjectWithData:dateData];
    if (!dateDic) {
        return nil;
    } else {
        NSDate *date = [dateDic objectForKey:[BSDataManager sharedInstance].currentUser.name_id];
        if (date) {
            return date;
        } else {
            return nil;
        }
    }
}

+ (void)savePopUpFirstActionDate:(NSDate *)date withKey:(NSString *)key{
    NSDate *dismissedDate = [BSUtility getPopUpFirstActionDate:key];
    if (!dismissedDate) {
        NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
        NSString *userID = [BSDataManager sharedInstance].currentUser.name_id;
        if (userID) {
            [dateDic setObject:date forKey:userID];
            [UserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dateDic] forKey:key];
            [UserDefaults synchronize];
        }
    }
}

+ (NSString *)MD5:(NSString *)string {
	// Create pointer to the string as UTF8
	const char *ptr = [string UTF8String];
 
	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
 
	// Create 16 byte MD5 hash value, store in buffer
	CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
 
	// Convert MD5 value in the buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x",md5Buffer[i]];
 
	return output;
}

@end
