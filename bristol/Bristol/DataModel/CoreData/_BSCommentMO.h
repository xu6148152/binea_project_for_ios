// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSCommentMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSCommentMOAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *identifier;
} BSCommentMOAttributes;

extern const struct BSCommentMORelationships {
	__unsafe_unretained NSString *highlight;
	__unsafe_unretained NSString *user;
} BSCommentMORelationships;

@class BSHighlightMO;
@class BSUserMO;

@interface BSCommentMOID : NSManagedObjectID {}
@end

@interface _BSCommentMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSCommentMOID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSHighlightMO *highlight;

//- (BOOL)validateHighlight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSUserMO *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _BSCommentMO (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (BSHighlightMO*)primitiveHighlight;
- (void)setPrimitiveHighlight:(BSHighlightMO*)value;

- (BSUserMO*)primitiveUser;
- (void)setPrimitiveUser:(BSUserMO*)value;

@end
