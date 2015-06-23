//
//  BSUserAcceptRequestToFollowHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserAcceptRequestToFollowHttpRequest.h"

@implementation BSUserAcceptRequestToFollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/accept_request_to_follow";
}

@end
