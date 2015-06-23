//
//  ZPFacebookActivity.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPFacebookActivity.h"

@implementation ZPFacebookActivity

- (NSString *)activityType {
	return @"com.zepplabs.activity.facebook";
}

- (NSString *)activityTitle {
	return @"Facebook";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"ZPActivityResources.bundle/Icon_Facebook.png"];
}

- (NSString *)serviceType {
	return SLServiceTypeFacebook;
}

@end
