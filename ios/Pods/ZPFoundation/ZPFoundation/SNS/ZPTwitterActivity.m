//
//  ZPTwitterActivity.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/26/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPTwitterActivity.h"

@implementation ZPTwitterActivity

- (NSString *)activityType {
	return @"com.zepplabs.activity.twitter";
}

- (NSString *)activityTitle {
	return @"Twitter";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"ZPActivityResources.bundle/Icon_Twitter.png"];
}

- (NSString *)serviceType {
	return SLServiceTypeTwitter;
}

@end
