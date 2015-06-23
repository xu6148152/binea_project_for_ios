//
//  BSHighlightLikeHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightLikeHttpRequest.h"
#import "BSHighlightMO.h"

@implementation BSHighlightLikeHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/like";
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
