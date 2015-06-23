//
//  BSTeamRejectInvitationHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamRejectInvitationHttpRequest.h"

@implementation BSTeamRejectInvitationHttpRequest
+ (NSString *)requestPath {
	return @"team/ignore_invitation";
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
