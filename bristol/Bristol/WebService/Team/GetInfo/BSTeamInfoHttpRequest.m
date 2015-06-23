//
//  BSTeamInfoHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInfoHttpRequest.h"
#import "BSTeamMO.h"

@implementation BSTeamInfoHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/info";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"team";
}

+ (RKMapping *)responseMapping {
	return [BSTeamMO responseMappingWithRecentHighlights];
}

@end
