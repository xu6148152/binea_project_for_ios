// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSNotificationMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSNotificationMOAttributes {
	__unsafe_unretained NSString *create_team_notification_type;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *current_rank;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *list_type;
	__unsafe_unretained NSString *local_has_read;
	__unsafe_unretained NSString *notification_type;
	__unsafe_unretained NSString *sport_type;
} BSNotificationMOAttributes;

extern const struct BSNotificationMORelationships {
	__unsafe_unretained NSString *comment;
	__unsafe_unretained NSString *event;
	__unsafe_unretained NSString *highlight;
	__unsafe_unretained NSString *sport;
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *user;
} BSNotificationMORelationships;

@class BSCommentMO;
@class BSEventMO;
@class BSHighlightMO;
@class BSSportMO;
@class BSTeamMO;
@class BSUserMO;

@interface BSNotificationMOID : NSManagedObjectID {}
@end

@interface _BSNotificationMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSNotificationMOID* objectID;

@property (nonatomic, strong) NSString* create_team_notification_type;

//- (BOOL)validateCreate_team_notification_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* current_rank;

@property (atomic) int16_t current_rankValue;
- (int16_t)current_rankValue;
- (void)setCurrent_rankValue:(int16_t)value_;

//- (BOOL)validateCurrent_rank:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* list_type;

@property (atomic) int16_t list_typeValue;
- (int16_t)list_typeValue;
- (void)setList_typeValue:(int16_t)value_;

//- (BOOL)validateList_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_has_read;

@property (atomic) BOOL local_has_readValue;
- (BOOL)local_has_readValue;
- (void)setLocal_has_readValue:(BOOL)value_;

//- (BOOL)validateLocal_has_read:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* notification_type;

@property (atomic) int16_t notification_typeValue;
- (int16_t)notification_typeValue;
- (void)setNotification_typeValue:(int16_t)value_;

//- (BOOL)validateNotification_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sport_type;

@property (atomic) int16_t sport_typeValue;
- (int16_t)sport_typeValue;
- (void)setSport_typeValue:(int16_t)value_;

//- (BOOL)validateSport_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSCommentMO *comment;

//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSEventMO *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSHighlightMO *highlight;

//- (BOOL)validateHighlight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSSportMO *sport;

//- (BOOL)validateSport:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSTeamMO *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSUserMO *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _BSNotificationMO (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCreate_team_notification_type;
- (void)setPrimitiveCreate_team_notification_type:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSNumber*)primitiveCurrent_rank;
- (void)setPrimitiveCurrent_rank:(NSNumber*)value;

- (int16_t)primitiveCurrent_rankValue;
- (void)setPrimitiveCurrent_rankValue:(int16_t)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveList_type;
- (void)setPrimitiveList_type:(NSNumber*)value;

- (int16_t)primitiveList_typeValue;
- (void)setPrimitiveList_typeValue:(int16_t)value_;

- (NSNumber*)primitiveLocal_has_read;
- (void)setPrimitiveLocal_has_read:(NSNumber*)value;

- (BOOL)primitiveLocal_has_readValue;
- (void)setPrimitiveLocal_has_readValue:(BOOL)value_;

- (NSNumber*)primitiveNotification_type;
- (void)setPrimitiveNotification_type:(NSNumber*)value;

- (int16_t)primitiveNotification_typeValue;
- (void)setPrimitiveNotification_typeValue:(int16_t)value_;

- (NSNumber*)primitiveSport_type;
- (void)setPrimitiveSport_type:(NSNumber*)value;

- (int16_t)primitiveSport_typeValue;
- (void)setPrimitiveSport_typeValue:(int16_t)value_;

- (BSCommentMO*)primitiveComment;
- (void)setPrimitiveComment:(BSCommentMO*)value;

- (BSEventMO*)primitiveEvent;
- (void)setPrimitiveEvent:(BSEventMO*)value;

- (BSHighlightMO*)primitiveHighlight;
- (void)setPrimitiveHighlight:(BSHighlightMO*)value;

- (BSSportMO*)primitiveSport;
- (void)setPrimitiveSport:(BSSportMO*)value;

- (BSTeamMO*)primitiveTeam;
- (void)setPrimitiveTeam:(BSTeamMO*)value;

- (BSUserMO*)primitiveUser;
- (void)setPrimitiveUser:(BSUserMO*)value;

@end
