// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSNotificationMO.m instead.

#import "_BSNotificationMO.h"

const struct BSNotificationMOAttributes BSNotificationMOAttributes = {
	.create_team_notification_type = @"create_team_notification_type",
	.created_at = @"created_at",
	.current_rank = @"current_rank",
	.identifier = @"identifier",
	.list_type = @"list_type",
	.local_has_read = @"local_has_read",
	.notification_type = @"notification_type",
	.sport_type = @"sport_type",
};

const struct BSNotificationMORelationships BSNotificationMORelationships = {
	.comment = @"comment",
	.event = @"event",
	.highlight = @"highlight",
	.sport = @"sport",
	.team = @"team",
	.user = @"user",
};

@implementation BSNotificationMOID
@end

@implementation _BSNotificationMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Notification";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:moc_];
}

- (BSNotificationMOID*)objectID {
	return (BSNotificationMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"current_rankValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"current_rank"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"list_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"list_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_has_readValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_has_read"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"notification_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notification_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sport_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sport_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic create_team_notification_type;

@dynamic created_at;

@dynamic current_rank;

- (int16_t)current_rankValue {
	NSNumber *result = [self current_rank];
	return [result shortValue];
}

- (void)setCurrent_rankValue:(int16_t)value_ {
	[self setCurrent_rank:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCurrent_rankValue {
	NSNumber *result = [self primitiveCurrent_rank];
	return [result shortValue];
}

- (void)setPrimitiveCurrent_rankValue:(int16_t)value_ {
	[self setPrimitiveCurrent_rank:[NSNumber numberWithShort:value_]];
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

@dynamic list_type;

- (int16_t)list_typeValue {
	NSNumber *result = [self list_type];
	return [result shortValue];
}

- (void)setList_typeValue:(int16_t)value_ {
	[self setList_type:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveList_typeValue {
	NSNumber *result = [self primitiveList_type];
	return [result shortValue];
}

- (void)setPrimitiveList_typeValue:(int16_t)value_ {
	[self setPrimitiveList_type:[NSNumber numberWithShort:value_]];
}

@dynamic local_has_read;

- (BOOL)local_has_readValue {
	NSNumber *result = [self local_has_read];
	return [result boolValue];
}

- (void)setLocal_has_readValue:(BOOL)value_ {
	[self setLocal_has_read:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLocal_has_readValue {
	NSNumber *result = [self primitiveLocal_has_read];
	return [result boolValue];
}

- (void)setPrimitiveLocal_has_readValue:(BOOL)value_ {
	[self setPrimitiveLocal_has_read:[NSNumber numberWithBool:value_]];
}

@dynamic notification_type;

- (int16_t)notification_typeValue {
	NSNumber *result = [self notification_type];
	return [result shortValue];
}

- (void)setNotification_typeValue:(int16_t)value_ {
	[self setNotification_type:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNotification_typeValue {
	NSNumber *result = [self primitiveNotification_type];
	return [result shortValue];
}

- (void)setPrimitiveNotification_typeValue:(int16_t)value_ {
	[self setPrimitiveNotification_type:[NSNumber numberWithShort:value_]];
}

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

@dynamic comment;

@dynamic event;

@dynamic highlight;

@dynamic sport;

@dynamic team;

@dynamic user;

@end

