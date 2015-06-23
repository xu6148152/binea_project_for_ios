//
//  BSHighlightAllLikesHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightAllLikesHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSHighlightAllLikesHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/likes";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"highlightId" : @"highlight_id",
	                                               @"lastUserId" : @"last_person" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSUsersDataModel responseMapping];
}

@end
