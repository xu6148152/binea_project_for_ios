//
//  BSHighlightReportHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightReportHttpRequest.h"

@implementation BSHighlightReportHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/report";
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
