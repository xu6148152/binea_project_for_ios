//
//  BSTeamAllHighlightsHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAllHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"

@implementation BSTeamAllHighlightsHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		self.countInOnePage = kDataCountInOnePage;
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/highlights";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id",
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
