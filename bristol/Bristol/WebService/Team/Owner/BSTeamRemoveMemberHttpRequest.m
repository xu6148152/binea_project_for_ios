//
//  BSTeamRemoveMemberHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamRemoveMemberHttpRequest.h"

@implementation BSTeamRemoveMemberHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/remove_member";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{
												  @"teamId" : @"team_id",
												  @"memberId" : @"member_id",
												  }];
	
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
