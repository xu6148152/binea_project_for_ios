//
//  BSSignInWithTwitterHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSignInWithTwitterHttpRequest.h"
#import "BSUserMO.h"

@interface BSSignInWithTwitterHttpRequest()
@property (nonatomic, strong) NSString *platform;

@end

@implementation BSSignInWithTwitterHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		_platform = @"ios";
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"account/sign_in_with_twitter";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"accessSecret" : @"oauth_secret",
	     @"accessToken" : @"oauth_access_token",
		 @"platform" : @"platform",
	     @"_locale" : @"locale",
	     @"_timezone" : @"timezone",
	 }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"user";
}

+ (RKMapping *)responseMapping {
	return [BSUserMO responseMapping];
}

@end
