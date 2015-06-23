//
//  BSHighlightUncommentHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightUncommentHttpRequest.h"
#import "BSHighlightMO.h"

@implementation BSHighlightUncommentHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/uncomment";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"highlightId" : @"highlight_id",
	                                               @"commentId" : @"comment_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
