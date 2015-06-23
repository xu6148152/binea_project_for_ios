//
//  BSHighlightUnlikeHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightUnlikeHttpRequest.h"
#import "BSHighlightMO.h"

@implementation BSHighlightUnlikeHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/unlike";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"highlightId" : @"highlight_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
