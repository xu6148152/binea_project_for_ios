//
//  BSUserInfoWithUsernameHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserInfoWithUsernameHttpRequest.h"
#import "BSUserMO.h"

@implementation BSUserInfoWithUsernameHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"user/profile";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"userName" : @"username" }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"user";
}

+ (RKMapping *)responseMapping {
	return [BSUserMO responseMappingWithUserProfile];
}

@end
