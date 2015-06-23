//
//  BSHighlightDeleteHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightDeleteHttpRequest.h"

@implementation BSHighlightDeleteHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/remove";
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
