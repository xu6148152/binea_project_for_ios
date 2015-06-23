//
//  BSNotificationsDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSNotificationsDataModel.h"
#import "BSNotificationMO.h"

@implementation BSNotificationsDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{@"last_read" : @"last_read_date"}];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"notifications" toKeyPath:@"notifications" withMapping:[BSNotificationMO responseMapping]]];
	
	return mapping;
}

@end
