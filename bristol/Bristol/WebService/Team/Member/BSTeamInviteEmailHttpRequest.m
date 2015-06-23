//
//  BSTeamInviteEmailHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 3/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInviteEmailHttpRequest.h"

@implementation BSTeamInviteEmailHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/invite_member_with_emails";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id",
												   @"emails" : @"emails"}];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}
@end
