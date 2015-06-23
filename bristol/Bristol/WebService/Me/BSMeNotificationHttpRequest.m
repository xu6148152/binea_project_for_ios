//
//  BSMeNotificationHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeNotificationHttpRequest.h"
#import "BSNotificationsDataModel.h"

@implementation BSMeNotificationHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"me/notifications";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSNotificationsDataModel responseMapping];
}

@end
