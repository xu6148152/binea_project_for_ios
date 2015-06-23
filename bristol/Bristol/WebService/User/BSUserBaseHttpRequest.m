//
//  BSUserBaseHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserBaseHttpRequest.h"

@implementation BSUserBaseHttpRequest

+ (instancetype)requestWithUserId:(DataModelIdType)userId {
	BSUserBaseHttpRequest *request = [[[self class] alloc] init];
	request.user_id = userId;
	return request;
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
