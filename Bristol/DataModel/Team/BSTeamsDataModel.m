//
//  BSTeamsDataModel.m
//  Bristol
//
//  Created by Yangfan Huang on 4/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamsDataModel.h"
#import "BSTeamMO.h"

@implementation BSTeamsDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"teams" toKeyPath:@"teams" withMapping:[BSTeamMO responseMappingWithUserTeams]]];
	
	return mapping;
}
@end
