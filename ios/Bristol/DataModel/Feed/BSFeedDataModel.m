//
//  BSFeedDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedDataModel.h"
#import "BSHighlightMO.h"
#import "BSEventMO.h"
#import "BSTeamMO.h"
#import "BSNotificationMO.h"

@implementation BSFeedDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];

	[mapping addAttributeMappingsFromDictionary:@{ @"count" : @"count",
	                                               @"last_highlight" : @"last_highlight" }];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlights" toKeyPath:@"highlights" withMapping:[BSHighlightMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recommended.event" toKeyPath:@"recomendEvents" withMapping:[BSEventMO responseMappingWithRecentHighlights]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recommended.team" toKeyPath:@"recomendTeams" withMapping:[BSTeamMO responseMappingWithRecentHighlights]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"notifications" toKeyPath:@"notifications" withMapping:[BSNotificationMO responseMappingWithFeedTimeline]]];
    
	return mapping;
}

@end
