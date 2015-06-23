//
//  BSTeamInvitationDataModel.m
//  Bristol
//
//  Created by Yangfan Huang on 3/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInvitationsDataModel.h"
#import "BSUserMO.h"

@implementation BSInvitationDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"type" : @"type",
												   @"email" : @"email" }];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[BSUserMO responseMapping]]];
	
	return mapping;
}

@end


@implementation BSTeamInvitationsDataModel

+ (NSString *)fromKeyPath {
	return @"invitations";
}

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"invitations" withMapping:[BSInvitationDataModel responseMapping]]];
	
	return mapping;
}
@end