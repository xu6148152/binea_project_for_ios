//
//  BSEventAllHighlightsHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventAllHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"

@implementation BSEventAllHighlightsHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		self.countInOnePage = kDataCountInOnePage;
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"event/highlights";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"eventId" : @"event_id",
												   @"startIndex" : @"start",
												   @"countInOnePage" : @"count", }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSHighlightsDataModel responseMapping];
}

@end
