//
//  BSUserRejectRequestToFollowHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserRejectRequestToFollowHttpRequest.h"

@implementation BSUserRejectRequestToFollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/reject_request_to_follow";
}

@end
