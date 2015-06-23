//
//  BSUserTeamsDataModel.m
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTeamsDataModel.h"
#import "BSTeamMO.h"
#import "BSUsersDataModel.h"

@implementation BSUserTeamsDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"followed_teams" toKeyPath:@"followedTeams" withMapping:[BSTeamMO responseMappingWithUserTeams]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"joined_teams" toKeyPath:@"joinedTeams" withMapping:[BSTeamMO responseMappingWithUserTeams]]];

    return mapping;
}

@end
