// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSCommentMO.m instead.

#import "_BSCommentMO.h"

const struct BSCommentMOAttributes BSCommentMOAttributes = {
	.content = @"content",
	.created_at = @"created_at",
	.identifier = @"identifier",
};

const struct BSCommentMORelationships BSCommentMORelationships = {
	.highlight = @"highlight",
	.user = @"user",
};

@implementation BSCommentMOID
@end

@implementation _BSCommentMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Comment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:moc_];
}

- (BSCommentMOID*)objectID {
	return (BSCommentMOID*)[super objectID];
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

@dynamic content;

@dynamic created_at;

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

@dynamic highlight;

@dynamic user;

@end

