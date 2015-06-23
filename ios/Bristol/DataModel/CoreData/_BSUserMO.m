// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSUserMO.m instead.

#import "_BSUserMO.h"

const struct BSUserMOAttributes BSUserMOAttributes = {
	.allow_comments = @"allow_comments",
	.avatar_url = @"avatar_url",
	.email = @"email",
	.events_count = @"events_count",
	.followers_count = @"followers_count",
	.following_count = @"following_count",
	.highlights_count = @"highlights_count",
	.identifier = @"identifier",
	.is_following = @"is_following",
	.is_public = @"is_public",
	.large_avatar_url = @"large_avatar_url",
	.local_is_sending_follow_request = @"local_is_sending_follow_request",
	.name_human_readable = @"name_human_readable",
	.name_id = @"name_id",
	.sport_type = @"sport_type",
	.teams_count = @"teams_count",
	.thumbnail_url = @"thumbnail_url",
	.video_url = @"video_url",
};

const struct BSUserMORelationships BSUserMORelationships = {
	.comments = @"comments",
	.events = @"events",
	.followed_teams = @"followed_teams",
	.highlights = @"highlights",
	.joined_teams = @"joined_teams",
	.recent_highlights = @"recent_highlights",
	.sports = @"sports",
};

@implementation BSUserMOID
@end

@implementation _BSUserMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (BSUserMOID*)objectID {
	return (BSUserMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"allow_commentsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"allow_comments"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"events_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"events_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"followers_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followers_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"following_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"following_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"highlights_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"highlights_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_followingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_following"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_publicValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_public"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_is_sending_follow_requestValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_is_sending_follow_request"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sport_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sport_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"teams_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"teams_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic allow_comments;

- (int16_t)allow_commentsValue {
	NSNumber *result = [self allow_comments];
	return [result shortValue];
}

- (void)setAllow_commentsValue:(int16_t)value_ {
	[self setAllow_comments:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveAllow_commentsValue {
	NSNumber *result = [self primitiveAllow_comments];
	return [result shortValue];
}

- (void)setPrimitiveAllow_commentsValue:(int16_t)value_ {
	[self setPrimitiveAllow_comments:[NSNumber numberWithShort:value_]];
}

@dynamic avatar_url;

@dynamic email;

@dynamic events_count;

- (int64_t)events_countValue {
	NSNumber *result = [self events_count];
	return [result longLongValue];
}

- (void)setEvents_countValue:(int64_t)value_ {
	[self setEvents_count:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveEvents_countValue {
	NSNumber *result = [self primitiveEvents_count];
	return [result longLongValue];
}

- (void)setPrimitiveEvents_countValue:(int64_t)value_ {
	[self setPrimitiveEvents_count:[NSNumber numberWithLongLong:value_]];
}

@dynamic followers_count;

- (int64_t)followers_countValue {
	NSNumber *result = [self followers_count];
	return [result longLongValue];
}

- (void)setFollowers_countValue:(int64_t)value_ {
	[self setFollowers_count:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveFollowers_countValue {
	NSNumber *result = [self primitiveFollowers_count];
	return [result longLongValue];
}

- (void)setPrimitiveFollowers_countValue:(int64_t)value_ {
	[self setPrimitiveFollowers_count:[NSNumber numberWithLongLong:value_]];
}

@dynamic following_count;

- (int64_t)following_countValue {
	NSNumber *result = [self following_count];
	return [result longLongValue];
}

- (void)setFollowing_countValue:(int64_t)value_ {
	[self setFollowing_count:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveFollowing_countValue {
	NSNumber *result = [self primitiveFollowing_count];
	return [result longLongValue];
}

- (void)setPrimitiveFollowing_countValue:(int64_t)value_ {
	[self setPrimitiveFollowing_count:[NSNumber numberWithLongLong:value_]];
}

@dynamic highlights_count;

- (int64_t)highlights_countValue {
	NSNumber *result = [self highlights_count];
	return [result longLongValue];
}

- (void)setHighlights_countValue:(int64_t)value_ {
	[self setHighlights_count:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveHighlights_countValue {
	NSNumber *result = [self primitiveHighlights_count];
	return [result longLongValue];
}

- (void)setPrimitiveHighlights_countValue:(int64_t)value_ {
	[self setPrimitiveHighlights_count:[NSNumber numberWithLongLong:value_]];
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

@dynamic is_following;

- (BOOL)is_followingValue {
	NSNumber *result = [self is_following];
	return [result boolValue];
}

- (void)setIs_followingValue:(BOOL)value_ {
	[self setIs_following:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_followingValue {
	NSNumber *result = [self primitiveIs_following];
	return [result boolValue];
}

- (void)setPrimitiveIs_followingValue:(BOOL)value_ {
	[self setPrimitiveIs_following:[NSNumber numberWithBool:value_]];
}

@dynamic is_public;

- (BOOL)is_publicValue {
	NSNumber *result = [self is_public];
	return [result boolValue];
}

- (void)setIs_publicValue:(BOOL)value_ {
	[self setIs_public:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_publicValue {
	NSNumber *result = [self primitiveIs_public];
	return [result boolValue];
}

- (void)setPrimitiveIs_publicValue:(BOOL)value_ {
	[self setPrimitiveIs_public:[NSNumber numberWithBool:value_]];
}

@dynamic large_avatar_url;

@dynamic local_is_sending_follow_request;

- (BOOL)local_is_sending_follow_requestValue {
	NSNumber *result = [self local_is_sending_follow_request];
	return [result boolValue];
}

- (void)setLocal_is_sending_follow_requestValue:(BOOL)value_ {
	[self setLocal_is_sending_follow_request:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLocal_is_sending_follow_requestValue {
	NSNumber *result = [self primitiveLocal_is_sending_follow_request];
	return [result boolValue];
}

- (void)setPrimitiveLocal_is_sending_follow_requestValue:(BOOL)value_ {
	[self setPrimitiveLocal_is_sending_follow_request:[NSNumber numberWithBool:value_]];
}

@dynamic name_human_readable;

@dynamic name_id;

@dynamic sport_type;

- (int32_t)sport_typeValue {
	NSNumber *result = [self sport_type];
	return [result intValue];
}

- (void)setSport_typeValue:(int32_t)value_ {
	[self setSport_type:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSport_typeValue {
	NSNumber *result = [self primitiveSport_type];
	return [result intValue];
}

- (void)setPrimitiveSport_typeValue:(int32_t)value_ {
	[self setPrimitiveSport_type:[NSNumber numberWithInt:value_]];
}

@dynamic teams_count;

- (int64_t)teams_countValue {
	NSNumber *result = [self teams_count];
	return [result longLongValue];
}

- (void)setTeams_countValue:(int64_t)value_ {
	[self setTeams_count:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTeams_countValue {
	NSNumber *result = [self primitiveTeams_count];
	return [result longLongValue];
}

- (void)setPrimitiveTeams_countValue:(int64_t)value_ {
	[self setPrimitiveTeams_count:[NSNumber numberWithLongLong:value_]];
}

@dynamic thumbnail_url;

@dynamic video_url;

@dynamic comments;

- (NSMutableSet*)commentsSet {
	[self willAccessValueForKey:@"comments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];

	[self didAccessValueForKey:@"comments"];
	return result;
}

@dynamic events;

- (NSMutableSet*)eventsSet {
	[self willAccessValueForKey:@"events"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"events"];

	[self didAccessValueForKey:@"events"];
	return result;
}

@dynamic followed_teams;

- (NSMutableSet*)followed_teamsSet {
	[self willAccessValueForKey:@"followed_teams"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"followed_teams"];

	[self didAccessValueForKey:@"followed_teams"];
	return result;
}

@dynamic highlights;

- (NSMutableSet*)highlightsSet {
	[self willAccessValueForKey:@"highlights"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"highlights"];

	[self didAccessValueForKey:@"highlights"];
	return result;
}

@dynamic joined_teams;

- (NSMutableSet*)joined_teamsSet {
	[self willAccessValueForKey:@"joined_teams"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"joined_teams"];

	[self didAccessValueForKey:@"joined_teams"];
	return result;
}

@dynamic recent_highlights;

- (NSMutableSet*)recent_highlightsSet {
	[self willAccessValueForKey:@"recent_highlights"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recent_highlights"];

	[self didAccessValueForKey:@"recent_highlights"];
	return result;
}

@dynamic sports;

- (NSMutableSet*)sportsSet {
	[self willAccessValueForKey:@"sports"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sports"];

	[self didAccessValueForKey:@"sports"];
	return result;
}

@end

