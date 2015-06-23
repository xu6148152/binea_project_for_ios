// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSSportMO.m instead.

#import "_BSSportMO.h"

const struct BSSportMOAttributes BSSportMOAttributes = {
	.identifier = @"identifier",
	.nameKey = @"nameKey",
};

const struct BSSportMORelationships BSSportMORelationships = {
	.highlights = @"highlights",
	.teams = @"teams",
	.users = @"users",
};

@implementation BSSportMOID
@end

@implementation _BSSportMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Sport" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Sport";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Sport" inManagedObjectContext:moc_];
}

- (BSSportMOID*)objectID {
	return (BSSportMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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

@dynamic nameKey;

@dynamic highlights;

- (NSMutableSet*)highlightsSet {
	[self willAccessValueForKey:@"highlights"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"highlights"];

	[self didAccessValueForKey:@"highlights"];
	return result;
}

@dynamic teams;

- (NSMutableSet*)teamsSet {
	[self willAccessValueForKey:@"teams"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teams"];

	[self didAccessValueForKey:@"teams"];
	return result;
}

@dynamic users;

- (NSMutableSet*)usersSet {
	[self willAccessValueForKey:@"users"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"users"];

	[self didAccessValueForKey:@"users"];
	return result;
}

@end

