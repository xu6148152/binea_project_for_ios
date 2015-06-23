//
//  BSTeamInviteMemberHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInviteMemberHttpRequest.h"

@implementation BSTeamInviteMemberHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/invite_member";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id",
												   @"userId" : @"user_id"}];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
