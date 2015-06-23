//
//  BSUserPublicFollowHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserPublicFollowHttpRequest.h"

@implementation BSUserPublicFollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/follow";
}

@end
