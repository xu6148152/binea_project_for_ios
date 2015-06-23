//
//  BSTeamAllFollowersHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAllFollowersHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSTeamAllFollowersHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/followers";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSFollowersDataModel responseMapping];
}

@end
