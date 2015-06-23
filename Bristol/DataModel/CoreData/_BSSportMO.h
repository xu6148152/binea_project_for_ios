// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSSportMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSSportMOAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *nameKey;
} BSSportMOAttributes;

extern const struct BSSportMORelationships {
	__unsafe_unretained NSString *highlights;
	__unsafe_unretained NSString *teams;
	__unsafe_unretained NSString *users;
} BSSportMORelationships;

@class BSHighlightMO;
@class BSTeamMO;
@class BSUserMO;

@interface BSSportMOID : NSManagedObjectID {}
@end

@interface _BSSportMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSSportMOID* objectID;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nameKey;

//- (BOOL)validateNameKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *highlights;

- (NSMutableSet*)highlightsSet;

@property (nonatomic, strong) NSSet *teams;

- (NSMutableSet*)teamsSet;

@property (nonatomic, strong) NSSet *users;

- (NSMutableSet*)usersSet;

@end

@interface _BSSportMO (HighlightsCoreDataGeneratedAccessors)
- (void)addHighlights:(NSSet*)value_;
- (void)removeHighlights:(NSSet*)value_;
- (void)addHighlightsObject:(BSHighlightMO*)value_;
- (void)removeHighlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSSportMO (TeamsCoreDataGeneratedAccessors)
- (void)addTeams:(NSSet*)value_;
- (void)removeTeams:(NSSet*)value_;
- (void)addTeamsObject:(BSTeamMO*)value_;
- (void)removeTeamsObject:(BSTeamMO*)value_;

@end

@interface _BSSportMO (UsersCoreDataGeneratedAccessors)
- (void)addUsers:(NSSet*)value_;
- (void)removeUsers:(NSSet*)value_;
- (void)addUsersObject:(BSUserMO*)value_;
- (void)removeUsersObject:(BSUserMO*)value_;

@end

@interface _BSSportMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSString*)primitiveNameKey;
- (void)setPrimitiveNameKey:(NSString*)value;

- (NSMutableSet*)primitiveHighlights;
- (void)setPrimitiveHighlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet*)value;

- (NSMutableSet*)primitiveUsers;
- (void)setPrimitiveUsers:(NSMutableSet*)value;

@end
