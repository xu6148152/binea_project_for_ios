// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSEventMO.m instead.

#import "_BSEventMO.h"

const struct BSEventMOAttributes BSEventMOAttributes = {
	.avatar_url = @"avatar_url",
	.cover_url = @"cover_url",
	.created_at = @"created_at",
	.end_time = @"end_time",
	.followers_count = @"followers_count",
	.highlights_count = @"highlights_count",
	.identifier = @"identifier",
	.is_active = @"is_active",
	.is_following = @"is_following",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
	.recommend_description = @"recommend_description",
	.start_time = @"start_time",
};

const struct BSEventMORelationships BSEventMORelationships = {
	.followers = @"followers",
	.highlights = @"highlights",
	.recent_followers = @"recent_followers",
	.recent_highlights = @"recent_highlights",
};

@implementation BSEventMOID
@end

@implementation _BSEventMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (BSEventMOID*)objectID {
	return (BSEventMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

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
	if ([key isEqualToString:@"is_activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_followingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_following"];
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

	return keyPaths;
}

@dynamic avatar_url;

@dynamic cover_url;

@dynamic created_at;

@dynamic end_time;

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

@dynamic is_active;

- (BOOL)is_activeValue {
	NSNumber *result = [self is_active];
	return [result boolValue];
}

- (void)setIs_activeValue:(BOOL)value_ {
	[self setIs_active:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_activeValue {
	NSNumber *result = [self primitiveIs_active];
	return [result boolValue];
}

- (void)setPrimitiveIs_activeValue:(BOOL)value_ {
	[self setPrimitiveIs_active:[NSNumber numberWithBool:value_]];
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

@dynamic name;

@dynamic recommend_description;

@dynamic start_time;

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

@dynamic recent_followers;

- (NSMutableSet*)recent_followersSet {
	[self willAccessValueForKey:@"recent_followers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recent_followers"];

	[self didAccessValueForKey:@"recent_followers"];
	return result;
}

@dynamic recent_highlights;

- (NSMutableSet*)recent_highlightsSet {
	[self willAccessValueForKey:@"recent_highlights"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recent_highlights"];

	[self didAccessValueForKey:@"recent_highlights"];
	return result;
}

@end

