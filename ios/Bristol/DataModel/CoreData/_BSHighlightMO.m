// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSHighlightMO.m instead.

#import "_BSHighlightMO.h"

const struct BSHighlightMOAttributes BSHighlightMOAttributes = {
	.comments_count = @"comments_count",
	.cover_url = @"cover_url",
	.created_at = @"created_at",
	.duration = @"duration",
	.frame_rate = @"frame_rate",
	.identifier = @"identifier",
	.is_can_comment = @"is_can_comment",
	.is_liked = @"is_liked",
	.latitude = @"latitude",
	.likes_count = @"likes_count",
	.local_cover_path = @"local_cover_path",
	.local_identifier = @"local_identifier",
	.local_index_in_feed = @"local_index_in_feed",
	.local_is_feed_highlight = @"local_is_feed_highlight",
	.local_is_wait_for_post = @"local_is_wait_for_post",
	.local_share_types = @"local_share_types",
	.local_share_url = @"local_share_url",
	.local_video_path = @"local_video_path",
	.location_name = @"location_name",
	.longitude = @"longitude",
	.loop_velocity = @"loop_velocity",
	.message = @"message",
	.played_times = @"played_times",
	.shoot_at = @"shoot_at",
	.sport_type = @"sport_type",
	.thumbnail_url = @"thumbnail_url",
	.video_size = @"video_size",
	.video_url = @"video_url",
	.watched_users = @"watched_users",
};

const struct BSHighlightMORelationships BSHighlightMORelationships = {
	.comments = @"comments",
	.event = @"event",
	.sport = @"sport",
	.team = @"team",
	.user = @"user",
};

@implementation BSHighlightMOID
@end

@implementation _BSHighlightMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Highlight" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Highlight";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Highlight" inManagedObjectContext:moc_];
}

- (BSHighlightMOID*)objectID {
	return (BSHighlightMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"comments_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comments_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"frame_rateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"frame_rate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_can_commentValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_can_comment"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_likedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_liked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"likes_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"likes_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_index_in_feedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_index_in_feed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_is_feed_highlightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_is_feed_highlight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_is_wait_for_postValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_is_wait_for_post"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"loop_velocityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loop_velocity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"played_timesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"played_times"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sport_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sport_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"video_sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"video_size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"watched_usersValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"watched_users"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic comments_count;

- (int32_t)comments_countValue {
	NSNumber *result = [self comments_count];
	return [result intValue];
}

- (void)setComments_countValue:(int32_t)value_ {
	[self setComments_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveComments_countValue {
	NSNumber *result = [self primitiveComments_count];
	return [result intValue];
}

- (void)setPrimitiveComments_countValue:(int32_t)value_ {
	[self setPrimitiveComments_count:[NSNumber numberWithInt:value_]];
}

@dynamic cover_url;

@dynamic created_at;

@dynamic duration;

- (int16_t)durationValue {
	NSNumber *result = [self duration];
	return [result shortValue];
}

- (void)setDurationValue:(int16_t)value_ {
	[self setDuration:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result shortValue];
}

- (void)setPrimitiveDurationValue:(int16_t)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithShort:value_]];
}

@dynamic frame_rate;

- (float)frame_rateValue {
	NSNumber *result = [self frame_rate];
	return [result floatValue];
}

- (void)setFrame_rateValue:(float)value_ {
	[self setFrame_rate:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveFrame_rateValue {
	NSNumber *result = [self primitiveFrame_rate];
	return [result floatValue];
}

- (void)setPrimitiveFrame_rateValue:(float)value_ {
	[self setPrimitiveFrame_rate:[NSNumber numberWithFloat:value_]];
}

@dynamic identifier;

- (int64_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result longLongValue];
}

- (void)setIdentifierValue:(int64_t)value_ {
	[self setIdentifier:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result longLongValue];
}

- (void)setPrimitiveIdentifierValue:(int64_t)value_ {
	[self setPrimitiveIdentifier:[NSNumber numberWithLongLong:value_]];
}

@dynamic is_can_comment;

- (BOOL)is_can_commentValue {
	NSNumber *result = [self is_can_comment];
	return [result boolValue];
}

- (void)setIs_can_commentValue:(BOOL)value_ {
	[self setIs_can_comment:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_can_commentValue {
	NSNumber *result = [self primitiveIs_can_comment];
	return [result boolValue];
}

- (void)setPrimitiveIs_can_commentValue:(BOOL)value_ {
	[self setPrimitiveIs_can_comment:[NSNumber numberWithBool:value_]];
}

@dynamic is_liked;

- (BOOL)is_likedValue {
	NSNumber *result = [self is_liked];
	return [result boolValue];
}

- (void)setIs_likedValue:(BOOL)value_ {
	[self setIs_liked:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_likedValue {
	NSNumber *result = [self primitiveIs_liked];
	return [result boolValue];
}

- (void)setPrimitiveIs_likedValue:(BOOL)value_ {
	[self setPrimitiveIs_liked:[NSNumber numberWithBool:value_]];
}

@dynamic latitude;

- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}

@dynamic likes_count;

- (int32_t)likes_countValue {
	NSNumber *result = [self likes_count];
	return [result intValue];
}

- (void)setLikes_countValue:(int32_t)value_ {
	[self setLikes_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLikes_countValue {
	NSNumber *result = [self primitiveLikes_count];
	return [result intValue];
}

- (void)setPrimitiveLikes_countValue:(int32_t)value_ {
	[self setPrimitiveLikes_count:[NSNumber numberWithInt:value_]];
}

@dynamic local_cover_path;

@dynamic local_identifier;

- (int64_t)local_identifierValue {
	NSNumber *result = [self local_identifier];
	return [result longLongValue];
}

- (void)setLocal_identifierValue:(int64_t)value_ {
	[self setLocal_identifier:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveLocal_identifierValue {
	NSNumber *result = [self primitiveLocal_identifier];
	return [result longLongValue];
}

- (void)setPrimitiveLocal_identifierValue:(int64_t)value_ {
	[self setPrimitiveLocal_identifier:[NSNumber numberWithLongLong:value_]];
}

@dynamic local_index_in_feed;

- (int16_t)local_index_in_feedValue {
	NSNumber *result = [self local_index_in_feed];
	return [result shortValue];
}

- (void)setLocal_index_in_feedValue:(int16_t)value_ {
	[self setLocal_index_in_feed:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLocal_index_in_feedValue {
	NSNumber *result = [self primitiveLocal_index_in_feed];
	return [result shortValue];
}

- (void)setPrimitiveLocal_index_in_feedValue:(int16_t)value_ {
	[self setPrimitiveLocal_index_in_feed:[NSNumber numberWithShort:value_]];
}

@dynamic local_is_feed_highlight;

- (BOOL)local_is_feed_highlightValue {
	NSNumber *result = [self local_is_feed_highlight];
	return [result boolValue];
}

- (void)setLocal_is_feed_highlightValue:(BOOL)value_ {
	[self setLocal_is_feed_highlight:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLocal_is_feed_highlightValue {
	NSNumber *result = [self primitiveLocal_is_feed_highlight];
	return [result boolValue];
}

- (void)setPrimitiveLocal_is_feed_highlightValue:(BOOL)value_ {
	[self setPrimitiveLocal_is_feed_highlight:[NSNumber numberWithBool:value_]];
}

@dynamic local_is_wait_for_post;

- (BOOL)local_is_wait_for_postValue {
	NSNumber *result = [self local_is_wait_for_post];
	return [result boolValue];
}

- (void)setLocal_is_wait_for_postValue:(BOOL)value_ {
	[self setLocal_is_wait_for_post:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLocal_is_wait_for_postValue {
	NSNumber *result = [self primitiveLocal_is_wait_for_post];
	return [result boolValue];
}

- (void)setPrimitiveLocal_is_wait_for_postValue:(BOOL)value_ {
	[self setPrimitiveLocal_is_wait_for_post:[NSNumber numberWithBool:value_]];
}

@dynamic local_share_types;

@dynamic local_share_url;

@dynamic local_video_path;

@dynamic location_name;

@dynamic longitude;

- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}

@dynamic loop_velocity;

- (float)loop_velocityValue {
	NSNumber *result = [self loop_velocity];
	return [result floatValue];
}

- (void)setLoop_velocityValue:(float)value_ {
	[self setLoop_velocity:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLoop_velocityValue {
	NSNumber *result = [self primitiveLoop_velocity];
	return [result floatValue];
}

- (void)setPrimitiveLoop_velocityValue:(float)value_ {
	[self setPrimitiveLoop_velocity:[NSNumber numberWithFloat:value_]];
}

@dynamic message;

@dynamic played_times;

- (int32_t)played_timesValue {
	NSNumber *result = [self played_times];
	return [result intValue];
}

- (void)setPlayed_timesValue:(int32_t)value_ {
	[self setPlayed_times:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePlayed_timesValue {
	NSNumber *result = [self primitivePlayed_times];
	return [result intValue];
}

- (void)setPrimitivePlayed_timesValue:(int32_t)value_ {
	[self setPrimitivePlayed_times:[NSNumber numberWithInt:value_]];
}

@dynamic shoot_at;

@dynamic sport_type;

- (int16_t)sport_typeValue {
	NSNumber *result = [self sport_type];
	return [result shortValue];
}

- (void)setSport_typeValue:(int16_t)value_ {
	[self setSport_type:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSport_typeValue {
	NSNumber *result = [self primitiveSport_type];
	return [result shortValue];
}

- (void)setPrimitiveSport_typeValue:(int16_t)value_ {
	[self setPrimitiveSport_type:[NSNumber numberWithShort:value_]];
}

@dynamic thumbnail_url;

@dynamic video_size;

- (int16_t)video_sizeValue {
	NSNumber *result = [self video_size];
	return [result shortValue];
}

- (void)setVideo_sizeValue:(int16_t)value_ {
	[self setVideo_size:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveVideo_sizeValue {
	NSNumber *result = [self primitiveVideo_size];
	return [result shortValue];
}

- (void)setPrimitiveVideo_sizeValue:(int16_t)value_ {
	[self setPrimitiveVideo_size:[NSNumber numberWithShort:value_]];
}

@dynamic video_url;

@dynamic watched_users;

- (int32_t)watched_usersValue {
	NSNumber *result = [self watched_users];
	return [result intValue];
}

- (void)setWatched_usersValue:(int32_t)value_ {
	[self setWatched_users:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWatched_usersValue {
	NSNumber *result = [self primitiveWatched_users];
	return [result intValue];
}

- (void)setPrimitiveWatched_usersValue:(int32_t)value_ {
	[self setPrimitiveWatched_users:[NSNumber numberWithInt:value_]];
}

@dynamic comments;

- (NSMutableSet*)commentsSet {
	[self willAccessValueForKey:@"comments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];

	[self didAccessValueForKey:@"comments"];
	return result;
}

@dynamic event;

@dynamic sport;

@dynamic team;

@dynamic user;

@end

