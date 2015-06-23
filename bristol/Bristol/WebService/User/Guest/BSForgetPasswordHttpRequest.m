//
//  BSForgetPasswordHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSForgetPasswordHttpRequest.h"

@implementation BSForgetPasswordHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		NSString *url;
#ifdef APPSTORE
		url = @"https://api.zepp.com/api/2/";
#else
		url = @"https://cint.zepp.com/api/2/";
#endif
		self.baseUrl = [NSURL URLWithString:url];
		self.statusSuccessValue = 200;
	}
	return self;
}

+ (NSString *)requestPath {
	return @"users/forgot_password";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"email" : @"email" }];
	
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
