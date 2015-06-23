#import "BSTeamMO.h"
#import "BSHighlightMO.h"
#import "BSUsersDataModel.h"
#import "BSUserMO.h"
#import "BSSportMO.h"

@interface BSTeamMO ()
{
	NSMutableSet *_pendingUsers;
	NSMutableSet *_pendingEmails;
}

@end

@implementation BSTeamMO

@synthesize pendingUsers;
@synthesize pendingEmails;

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	return mapping;
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Team" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"id":@"identifier",
	     @"name":@"name",
         @"avatar_url":@"avatar_url",
		 @"cover_url":@"cover_url",
         @"followers_count":@"followers_count",
         @"highlights_count":@"highlights_count",
         @"members_count":@"members_count",
		 @"private":@"is_private",
		 @"joinable":@"is_joinable",
		 @"location":@"location",
		 @"longitude":@"longitude",
		 @"latitude":@"latitude",
		 @"relationship.is_following":@"is_following",
		 @"relationship.is_member":@"is_member",
		 @"relationship.is_manager":@"is_manager",
		 @"relationship.is_applying":@"is_applying",
		 @"relationship.is_invited":@"is_invited",
         }];

	mapping.identificationAttributes = @[@"identifier"];

	return mapping;
}

+ (RKMapping *)responseMappingWithRecentHighlights {
    RKEntityMapping *mapping = (RKEntityMapping *)[BSTeamMO responseMapping];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sports" toKeyPath:@"sports" withMapping:[BSSportMO responseMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];
    
    return mapping;
}

+ (RKMapping *)responseMappingWithUserTeams {
	RKEntityMapping *mapping = (RKEntityMapping *)[BSTeamMO responseMapping];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"members" toKeyPath:@"members" withMapping:[BSUserMO responseMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];
    
    return mapping;
}


- (void)randomPropertiesForTest {
    self.avatar_url = @"https://avatars.githubusercontent.com/u/37303?placeholder";
    self.name = [NSString randomStringWithLength:[NSNumber randomUIntegerFrom:10 to:100]];
	self.created_at = [NSDate date];
	self.updated_at = [NSDate date];
}

+ (instancetype)randomInstanceForTest {
    BSTeamMO *mo = [BSTeamMO createEntity];
    [mo randomPropertiesForTest];

	return mo;
}

- (NSArray *)sportsSortedByAlphabet {
	return [self.sports sortedArrayWithKey:@"nameKey" ascending:YES];
}

- (NSArray *)membersSortedByAlphabet {
	return [self.members sortedArrayWithKey:@"name_id" ascending:YES];
}

- (NSArray *)followersSortedByAlphabet {
	return [self.followers sortedArrayWithKey:@"name_id" ascending:YES];
}

- (NSMutableSet *)pendingUsers {
	if (!_pendingUsers) {
		_pendingUsers = [NSMutableSet set];
	}
	return _pendingUsers;
}

- (NSMutableSet *)pendingEmails {
	if (!_pendingEmails) {
		_pendingEmails = [NSMutableSet set];
	}
	return _pendingEmails;
}

@end
