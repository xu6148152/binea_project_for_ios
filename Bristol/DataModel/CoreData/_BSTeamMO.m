// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSTeamMO.m instead.

#import "_BSTeamMO.h"

const struct BSTeamMOAttributes BSTeamMOAttributes = {
	.avatar_url = @"avatar_url",
	.cover_url = @"cover_url",
	.created_at = @"created_at",
	.creator_id = @"creator_id",
	.followers_count = @"followers_count",
	.highlights_count = @"highlights_count",
	.identifier = @"identifier",
	.is_applying = @"is_applying",
	.is_following = @"is_following",
	.is_invited = @"is_invited",
	.is_joinable = @"is_joinable",
	.is_manager = @"is_manager",
	.is_member = @"is_member",
	.is_private = @"is_private",
	.latitude = @"latitude",
	.location = @"location",
	.longitude = @"longitude",
	.members_count = @"members_count",
	.name = @"name",
	.updated_at = @"updated_at",
};

const struct BSTeamMORelationships BSTeamMORelationships = {
	.followers = @"followers",
	.highlights = @"highlights",
	.members = @"members",
	.recent_highlights = @"recent_highlights",
	.sports = @"sports",
};

@implementation BSTeamMOID
@end

@implementation _BSTeamMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (BSTeamMOID*)objectID {
	return (BSTeamMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"creator_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"creator_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"followers_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followers_count"];
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
	if ([key isEqualToString:@"is_applyingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_applying"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_followingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_following"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_invitedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_invited"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_joinableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_joinable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_managerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_manager"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_memberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_member"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_privateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_private"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"members_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"members_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic avatar_url;

@dynamic cover_url;

@dynamic created_at;

@dynamic creator_id;

- (int64_t)creator_idValue {
	NSNumber *result = [self creator_id];
	return [result longLongValue];
}

- (void)setCreator_idValue:(int64_t)value_ {
	[self setCreator_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveCreator_idValue {
	NSNumber *result = [self primitiveCreator_id];
	return [result longLongValue];
}

- (void)setPrimitiveCreator_idValue:(int64_t)value_ {
	[self setPrimitiveCreator_id:[NSNumber numberWithLongLong:value_]];
}

@dynamic followers_count;

- (int32_t)followers_countValue {
	NSNumber *result = [self followers_count];
	return [result intValue];
}

- (void)setFollowers_countValue:(int32_t)value_ {
	[self setFollowers_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowers_countValue {
	NSNumber *result = [self primitiveFollowers_count];
	return [result intValue];
}

- (void)setPrimitiveFollowers_countValue:(int32_t)value_ {
	[self setPrimitiveFollowers_count:[NSNumber numberWithInt:value_]];
}

@dynamic highlights_count;

- (int32_t)highlights_countValue {
	NSNumber *result = [self highlights_count];
	return [result intValue];
}

- (void)setHighlights_countValue:(int32_t)value_ {
	[self setHighlights_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveHighlights_countValue {
	NSNumber *result = [self primitiveHighlights_count];
	return [result intValue];
}

- (void)setPrimitiveHighlights_countValue:(int32_t)value_ {
	[self setPrimitiveHighlights_count:[NSNumber numberWithInt:value_]];
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

@dynamic is_applying;

- (BOOL)is_applyingValue {
	NSNumber *result = [self is_applying];
	return [result boolValue];
}

- (void)setIs_applyingValue:(BOOL)value_ {
	[self setIs_applying:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_applyingValue {
	NSNumber *result = [self primitiveIs_applying];
	return [result boolValue];
}

- (void)setPrimitiveIs_applyingValue:(BOOL)value_ {
	[self setPrimitiveIs_applying:[NSNumber numberWithBool:value_]];
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

@dynamic is_invited;

- (BOOL)is_invitedValue {
	NSNumber *result = [self is_invited];
	return [result boolValue];
}

- (void)setIs_invitedValue:(BOOL)value_ {
	[self setIs_invited:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_invitedValue {
	NSNumber *result = [self primitiveIs_invited];
	return [result boolValue];
}

- (void)setPrimitiveIs_invitedValue:(BOOL)value_ {
	[self setPrimitiveIs_invited:[NSNumber numberWithBool:value_]];
}

@dynamic is_joinable;

- (BOOL)is_joinableValue {
	NSNumber *result = [self is_joinable];
	return [result boolValue];
}

- (void)setIs_joinableValue:(BOOL)value_ {
	[self setIs_joinable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_joinableValue {
	NSNumber *result = [self primitiveIs_joinable];
	return [result boolValue];
}

- (void)setPrimitiveIs_joinableValue:(BOOL)value_ {
	[self setPrimitiveIs_joinable:[NSNumber numberWithBool:value_]];
}

@dynamic is_manager;

- (BOOL)is_managerValue {
	NSNumber *result = [self is_manager];
	return [result boolValue];
}

- (void)setIs_managerValue:(BOOL)value_ {
	[self setIs_manager:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_managerValue {
	NSNumber *result = [self primitiveIs_manager];
	return [result boolValue];
}

- (void)setPrimitiveIs_managerValue:(BOOL)value_ {
	[self setPrimitiveIs_manager:[NSNumber numberWithBool:value_]];
}

@dynamic is_member;

- (BOOL)is_memberValue {
	NSNumber *result = [self is_member];
	return [result boolValue];
}

- (void)setIs_memberValue:(BOOL)value_ {
	[self setIs_member:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_memberValue {
	NSNumber *result = [self primitiveIs_member];
	return [result boolValue];
}

- (void)setPrimitiveIs_memberValue:(BOOL)value_ {
	[self setPrimitiveIs_member:[NSNumber numberWithBool:value_]];
}

@dynamic is_private;

- (BOOL)is_privateValue {
	NSNumber *result = [self is_private];
	return [result boolValue];
}

- (void)setIs_privateValue:(BOOL)value_ {
	[self setIs_private:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_privateValue {
	NSNumber *result = [self primitiveIs_private];
	return [result boolValue];
}

- (void)setPrimitiveIs_privateValue:(BOOL)value_ {
	[self setPrimitiveIs_private:[NSNumber numberWithBool:value_]];
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

@dynamic location;

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

@dynamic members_count;

- (int32_t)members_countValue {
	NSNumber *result = [self members_count];
	return [result intValue];
}

- (void)setMembers_countValue:(int32_t)value_ {
	[self setMembers_count:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMembers_countValue {
	NSNumber *result = [self primitiveMembers_count];
	return [result intValue];
}

- (void)setPrimitiveMembers_countValue:(int32_t)value_ {
	[self setPrimitiveMembers_count:[NSNumber numberWithInt:value_]];
}

@dynamic name;

@dynamic updated_at;

@dynamic followers;

- (NSMutableSet*)followersSet {
	[self willAccessValueForKey:@"followers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"followers"];

	[self didAccessValueForKey:@"followers"];
	return result;
}

@dynamic highlights;

- (NSMutableSet*)highlightsSet {
	[self willAccessValueForKey:@"highlights"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"highlights"];

	[self didAccessValueForKey:@"highlights"];
	return result;
}

@dynamic members;

- (NSMutableSet*)membersSet {
	[self willAccessValueForKey:@"members"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];

	[self didAccessValueForKey:@"members"];
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

