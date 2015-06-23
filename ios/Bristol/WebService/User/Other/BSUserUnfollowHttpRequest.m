//
//  BSUserUnfollowHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserUnfollowHttpRequest.h"

@implementation BSUserUnfollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/unfollow";
}

@end
