#import "BSEventMO.h"
#import "BSHighlightMO.h"
#import "BSUserMO.h"

@interface BSEventMO ()

@end

@implementation BSEventMO

- (CLLocationCoordinate2D)coordinate {
	return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	return mapping;
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"avatar_url":@"avatar_url",
	     @"cover_url":@"cover_url",
	     @"created_at":@"created_at",
	     @"end_time":@"end_time",
	     @"followers_count":@"followers_count",
	     @"highlights_count":@"highlights_count",
	     @"id":@"identifier",
	     @"relationship.is_following":@"is_following",
	     @"latitude":@"latitude",
	     @"longitude":@"longitude",
	     @"name":@"name",
	     @"description":@"recommend_description",
	     @"start_time":@"start_time",
         @"active":@"is_active",
	 }];


	mapping.identificationAttributes = @[@"identifier"];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"followers" toKeyPath:@"followers" withMapping:[BSUserMO responseMapping]]];

	return mapping;
}

+ (RKMapping *)responseMappingWithRecentHighlights {
	RKEntityMapping *mapping = (RKEntityMapping *)[BSEventMO responseMapping];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];

	return mapping;
}

+ (RKMapping *)responseMappingWithUserEvents {
	RKEntityMapping *mapping = (RKEntityMapping *)[BSEventMO responseMapping];

	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_followers" toKeyPath:@"recent_followers" withMapping:[BSUserMO responseMapping]]];

	mapping.identificationAttributes = @[@"identifier"];
	return mapping;
}

- (void)randomPropertiesForTest {
	self.avatar_url = @"https://avatars.githubusercontent.com/u/37303?placeholder";
	self.name = [NSString randomStringWithLength:[NSNumber randomUIntegerFrom:10 to:100]];
	self.start_time = [NSDate randomDate];
}

+ (instancetype)randomInstanceForTest {
	BSEventMO *mo = [BSEventMO createEntity];
	[mo randomPropertiesForTest];

	return mo;
}

- (NSArray *)recent_followersSortedByAlphabet {
	return [self.recent_followers sortedArrayWithKey:@"name_id" ascending:YES];
}

- (NSArray *)followersSortedByAlphabet {
	return [self.followers sortedArrayWithKey:@"name_id" ascending:YES];
}

@end
