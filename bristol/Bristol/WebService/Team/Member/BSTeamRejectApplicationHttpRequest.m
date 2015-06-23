//
//  BSTeamRejectApplicationHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamRejectApplicationHttpRequest.h"

@implementation BSTeamRejectApplicationHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/reject_application";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"teamId" : @"team_id",
	     @"userId" : @"user_id",
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
