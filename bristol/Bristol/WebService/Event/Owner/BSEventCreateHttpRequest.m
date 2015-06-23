//
//  BSEventCreateHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventCreateHttpRequest.h"
#import "BSEventMO.h"

@implementation BSEventCreateHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"event/create";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"event.name" : @"event.name",
	     @"event.start_time" : @"event.start_time",
	 }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

// api reponse not defined yet
+ (RKMapping *)responseMapping {
    return nil;
//	return [BSEventMO responseMapping];
}

@end
