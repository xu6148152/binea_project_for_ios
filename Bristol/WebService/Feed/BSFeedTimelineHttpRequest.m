//
//  BSFeedTimelineHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedTimelineHttpRequest.h"
#import "BSFeedDataModel.h"
#import "BSHighlightMO.h"

@implementation BSFeedTimelineHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		self.countInOnePage = kDataCountInOnePage;
		self.latitude = self.longitude = kInvalidCoordinate;
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"feeds/timeline";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"olderThanHighlightId" : @"older_than",
												   @"startIndex" : @"start",
												   @"countInOnePage" : @"count",
												   @"latitude" : @"latitude",
												   @"longitude" : @"longitude",
												   @"show_create_team_notification" : @"show_create_team_notification" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSFeedDataModel responseMapping];
}

- (void)onRequestSucceed:(BSHttpResponseDataModel *)result {
	BSFeedDataModel *dataModel = (BSFeedDataModel *)result.dataModel;
	for (BSHighlightMO *highlight in dataModel.highlights) {
		highlight.local_is_feed_highlightValue = YES;
	}
}

@end
