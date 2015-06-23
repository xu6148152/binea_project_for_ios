//
//  BSUserPrivateFollowHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserPrivateFollowHttpRequest.h"

@implementation BSUserPrivateFollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/request_to_follow";
}

@end
