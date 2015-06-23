//
//  BSEventCloseFromTimelineHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventCloseFromTimelineHttpRequest.h"

@implementation BSEventCloseFromTimelineHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"event/close_from_timeline";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"eventId" : @"event_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
