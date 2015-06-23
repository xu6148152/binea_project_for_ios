//
//  BSSignInWithFacebookHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSignInWithFacebookHttpRequest.h"
#import "BSUserMO.h"

@interface BSSignInWithFacebookHttpRequest ()


@end

@implementation BSSignInWithFacebookHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"account/sign_in_with_facebook";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"accessToken" : @"oauth_access_token",
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
