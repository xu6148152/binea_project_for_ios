#import "BSHighlightMO.h"
#import "BSTeamMO.h"
#import "BSEventMO.h"
#import "BSUserMO.h"
#import "BSCommentMO.h"

@interface BSHighlightMO ()

@end

@implementation BSHighlightMO
@synthesize showSeeAllCommentsCell;

- (void)setLikes_countValue:(int32_t)value_ {
	if (value_ >= 0) {
		[super setLikes_countValue:value_];
	}
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	return mapping;
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Highlight" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"id":@"identifier",
	     @"sport_type":@"sport_type",
	     @"message":@"message",
	     @"video_url":@"video_url",
	     @"low_video_url":@"low_video_url",
	     @"high_video_url":@"high_video_url",
	     @"cover_url":@"cover_url",
	     @"thumbnail_url":@"thumbnail_url",
	     @"shoot_at":@"shoot_at",
	     @"latitude":@"latitude",
	     @"longitude":@"longitude",
		 @"location":@"location_name",
	     @"loop_velocity":@"loop_velocity",
	     @"frame_rate":@"frame_rate",
	     @"video_size":@"video_size",
	     @"duration":@"duration",
	     @"likes":@"likes_count",
	     @"watched_users":@"watched_users",
	     @"played_times":@"played_times",
	     @"comments_count":@"comments_count",
	     @"created_at":@"created_at",
		 @"relationship.liked":@"is_liked",
		 @"relationship.can_comment":@"is_can_comment",
	 }];

	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[BSUserMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"team" toKeyPath:@"team" withMapping:[BSTeamMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"event" toKeyPath:@"event" withMapping:[BSEventMO responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comments" withMapping:[BSCommentMO responseMapping]]];

	mapping.identificationAttributes = @[@"identifier"];

	return mapping;
}

- (void)randomPropertiesForTest {
    self.message = [NSString randomStringWithLength:[NSNumber randomUIntegerFrom:10 to:100]];
    self.shoot_at = [NSDate randomDate];
}

+ (instancetype)randomInstanceForTest {
    BSHighlightMO *mo = [BSHighlightMO createEntity];
    [mo randomPropertiesForTest];

	return mo;
}

- (NSArray *)commentsSortedByCreate_AtAsc {
	return [self.comments sortedArrayWithKey:@"created_at" ascending:YES];
}

@end
