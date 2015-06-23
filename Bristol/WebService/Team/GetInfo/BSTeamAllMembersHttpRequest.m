//
//  BSTeamAllMembersHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAllMembersHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSTeamMO.h"

@implementation BSTeamAllMembersHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/members";
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
	return [BSMembersDataModel responseMapping];
}

- (void) onRequestSucceed:(BSHttpResponseDataModel *)result {
	BSTeamMO *team = [BSTeamMO MR_findFirstByAttribute:@"identifier" withValue:@(self.teamId)];
	if (team) {
		if (team.members) {
			[team removeMembers:team.members];
		}
		
		NSArray *members = ((BSMembersDataModel *)result.dataModel).users;
		if (members) {
			[team addMembers:[NSSet setWithArray:members]];
		}
	}
}

@end
