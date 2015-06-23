#import "BSUserMO.h"
#import "BSHighlightMO.h"
#import "BSSportMO.h"
#import "BSDataManager.h"

@interface BSUserMO ()
{
	NSMutableSet *_pendingUsers;
}

@end

@implementation BSUserMO

@synthesize pendingUsers;

- (void)setHighlights_countValue:(int64_t)value_ {
	if (value_ >= 0) {
		[super setHighlights_countValue:value_];
	}
}

- (void)setTeams_countValue:(int64_t)value_ {
	if (value_ >= 0) {
		[super setTeams_countValue:value_];
	}
}

- (void)setEvents_countValue:(int64_t)value_ {
	if (value_ >= 0) {
		[super setEvents_countValue:value_];
	}
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	return mapping;
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"id":@"identifier",
	     @"username":@"name_id",
         @"screen_name":@"name_human_readable",
	     @"avatar_url":@"avatar_url",
		 @"email":@"email",
         @"allow_comments":@"allow_comments",
         @"public_profile":@"is_public",
         @"friendship.is_following":@"is_following",
	     @"friendship.following_me":@"following_me",
		 }];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sports" toKeyPath:@"sports" withMapping:[BSSportMO responseMapping]]];

	mapping.identificationAttributes = @[@"identifier"];

	return mapping;
}

+ (RKMapping *)responseMappingWithRecentHighlights {
    RKEntityMapping *mapping = (RKEntityMapping *)[BSUserMO responseMapping];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];
	
    return mapping;
}   

+ (RKMapping *)responseMappingWithUserProfile {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id":@"identifier",
                                                  @"username":@"name_id",
                                                  @"screen_name":@"name_human_readable",
												  @"avatar_url":@"avatar_url",
												  @"email":@"email",
                                                  @"following":@"following_count",
                                                  @"followers":@"followers_count",
                                                  @"teams_count":@"teams_count",
                                                  @"events_count":@"events_count",
                                                  @"large_avatar_url":@"large_avatar_url",
                                                  @"privacy.allow_comments":@"allow_comments",
                                                  @"privacy.public_profile":@"is_public",
                                                  @"highlights_count":@"highlights_count",
                                                  }];
    
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"recent_highlights" toKeyPath:@"recent_highlights" withMapping:[BSHighlightMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"sports" toKeyPath:@"sports" withMapping:[BSSportMO responseMapping]]];
	
    mapping.identificationAttributes = @[@"identifier"];
    return mapping;
}

- (void)randomPropertiesForTest {
    self.avatar_url = @"https://avatars.githubusercontent.com/u/37303?placeholder";
    self.name_id = [NSString randomStringWithLength:[NSNumber randomUIntegerFrom:10 to:100]];
}

+ (instancetype)randomInstanceForTest {
    BSUserMO *mo = [BSUserMO createEntity];
    [mo randomPropertiesForTest];

	return mo;
}

+ (instancetype)createEntityAndSetDefaultValues {
    BSUserMO *user = [BSUserMO createEntity];
    
    return user;
}

- (NSArray *)sportsSortedByAlphabet {
	return [self.sports sortedArrayWithKey:@"nameKey" ascending:YES];
}

- (NSMutableSet *)pendingUsers {
	if (!_pendingUsers) {
		_pendingUsers = [NSMutableSet set];
	}
	return _pendingUsers;
}

@end
