//
//  BSTeamPendingApplicationsHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamPendingApplicationsHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSTeamPendingApplicationsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/pending_applications";
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
	return [BSUsersDataModel responseMapping];
}

@end
