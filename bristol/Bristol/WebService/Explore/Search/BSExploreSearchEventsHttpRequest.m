//
//  BSExploreSearchEventsHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchEventsHttpRequest.h"
#import "BSEventsDataModel.h"

@implementation BSExploreSearchEventsHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"explore/search_events";
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSEventsUserKeyDataModel responseMapping];
}
@end
