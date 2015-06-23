//
//  BSHighlightGetShareUrlHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightGetShareUrlHttpRequest.h"

@implementation BSHighlightGetShareUrlHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/get_share_url";
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
	return [BSHighlightShareUrlDataModel responseMapping];
}

@end
