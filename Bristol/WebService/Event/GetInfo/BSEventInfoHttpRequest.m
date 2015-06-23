//
//  BSEventInfoHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventInfoHttpRequest.h"
#import "BSEventMO.h"

@implementation BSEventInfoHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"event/info";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"eventId" : @"event_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"event";
}

+ (RKMapping *)responseMapping {
	return [BSEventMO responseMappingWithRecentHighlights];
}

@end
