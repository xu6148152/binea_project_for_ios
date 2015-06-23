//
//  BSUserTeamsHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTeamsHttpRequest.h"
#import "BSUserTeamsDataModel.h"
#import "BSDataModels.h"

@implementation BSUserTeamsHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"user/teams";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id" }];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSUserTeamsDataModel responseMapping];
}

- (void) onRequestSucceed:(BSHttpResponseDataModel *)result {
	BSUserMO *user = [BSUserMO MR_findFirstByAttribute:@"identifier" withValue:@(self.user_id)];
	if (user) {
		if (user.joined_teams) {
			[user removeJoined_teams:user.joined_teams];
		}
		if (user.followed_teams) {
			[user removeFollowed_teams:user.followed_teams];
		}

		for (BSTeamMO *team in ((BSUserTeamsDataModel *)result.dataModel).followedTeams) {
			[user addFollowed_teamsObject:team];
		}
		
		for (BSTeamMO *team in ((BSUserTeamsDataModel *)result.dataModel).joinedTeams) {
			[user addJoined_teamsObject:team];
		}
	}
}

@end
