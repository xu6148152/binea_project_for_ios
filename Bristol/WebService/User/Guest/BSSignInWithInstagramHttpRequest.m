//
//  BSSignInWithInstagramHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSignInWithInstagramHttpRequest.h"
#import "BSUserMO.h"

@implementation BSSignInWithInstagramHttpRequest

#pragma mark - overwrite -
+ (RKRequestMethod)requestMethod {
	return RKRequestMethodGET;
}

+ (NSString *)requestPath {
	return @"oauth/instagram-callback";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"code" : @"code", }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"user";
}

+ (RKMapping *)responseMapping {
	return [BSUserMO responseMapping];
}

@end
