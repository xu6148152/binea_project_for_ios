//
//  BSFeedCheckHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedCheckHttpRequest.h"

@implementation BSFeedCheckHttpRequest

+ (NSString *)requestPath {
	return @"feeds/check";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"lastHighlightId" : @"last_id", }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSNewFeedDataModel responseMapping];
}

@end
