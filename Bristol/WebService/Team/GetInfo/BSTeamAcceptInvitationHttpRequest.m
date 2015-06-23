//
//  BSTeamAcceptInvitationHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 4/10/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAcceptInvitationHttpRequest.h"

@implementation BSTeamAcceptInvitationHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/accept_invitation";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id",}];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
