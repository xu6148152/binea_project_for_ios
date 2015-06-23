//
//  BSHighlightAllCommentsHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightAllCommentsHttpRequest.h"
#import "BSHighlightCommentsDataModel.h"

@implementation BSHighlightAllCommentsHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		_olderThanCommentId = -1;
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/comments";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"highlightId" : @"highlight_id",
	                                               @"olderThanCommentId" : @"older_than" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSHighlightCommentsDataModel responseMapping];
}

@end
