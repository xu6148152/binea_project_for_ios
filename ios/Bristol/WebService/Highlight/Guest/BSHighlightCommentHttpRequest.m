//
//  BSHighlightCommentHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightCommentHttpRequest.h"
#import "BSHighlightCommentsDataModel.h"

@implementation BSHighlightCommentHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/comment";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"highlightId" : @"highlight_id",
	                                               @"content" : @"content" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSHighlightCommentsDataModel addCommentResponseMapping];
}

@end
