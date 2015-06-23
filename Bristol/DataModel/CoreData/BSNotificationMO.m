#import "BSNotificationMO.h"
#import "BSDataModels.h"

@interface BSNotificationMO ()

// Private interface goes here.

@end

@implementation BSNotificationMO

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Notification" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
	
	[mapping addAttributeMappingsFromDictionary:@{
												  @"id":@"identifier",
												  @"type":@"notification_type",
												  @"sport_type":@"sport_type",
												  @"created_at":@"created_at",
												  @"data.list_type":@"list_type",
												  @"data.current_rank":@"current_rank",
												  }];
	
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[BSUserMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlight" toKeyPath:@"highlight" withMapping:[BSHighlightMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comment" toKeyPath:@"comment" withMapping:[BSCommentMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"event" toKeyPath:@"event" withMapping:[BSEventMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sport" toKeyPath:@"sport" withMapping:[BSSportMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"team" toKeyPath:@"team" withMapping:[BSTeamMO responseMapping]]];
	
	mapping.identificationAttributes = @[@"identifier"];
	
	return mapping;
}

+ (RKMapping *)responseMappingWithFeedTimeline {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Notification" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"type":@"create_team_notification_type" }];
    
    return mapping;
}


- (void)randomPropertiesForTest {
	self.notification_typeValue = [NSNumber randomUIntegerFrom:1 to:10];
	self.sport_typeValue = [NSNumber randomUIntegerFrom:1 to:16];
	self.created_at = [NSDate randomDate];
}

+ (instancetype)randomInstanceForTest {
	BSNotificationMO *mo = [BSNotificationMO createEntity];
	[mo randomPropertiesForTest];
	
	return mo;
}

- (NSString *)formatedTextForTypeHelpMeTop {
	NSString *channel = @"";
	switch (self.list_typeValue) {
		case BSToptenChannelTypeFriends:
			channel = ZPLocalizedString(@"my friends list");
			break;
		case BSToptenChannelTypeEvents:
			channel = self.event.name;
			break;
		case BSToptenChannelTypeSports:
			channel = self.sport.nameLocalized;
			break;
	}
	NSString *text = [NSString stringWithFormat:ZPLocalizedString(@"Help me to top 10 format"), self.current_rank, channel];
	return text;
}

@end
