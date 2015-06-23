// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSTeamMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSTeamMOAttributes {
	__unsafe_unretained NSString *avatar_url;
	__unsafe_unretained NSString *cover_url;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *creator_id;
	__unsafe_unretained NSString *followers_count;
	__unsafe_unretained NSString *highlights_count;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *is_applying;
	__unsafe_unretained NSString *is_following;
	__unsafe_unretained NSString *is_invited;
	__unsafe_unretained NSString *is_joinable;
	__unsafe_unretained NSString *is_manager;
	__unsafe_unretained NSString *is_member;
	__unsafe_unretained NSString *is_private;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *members_count;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *updated_at;
} BSTeamMOAttributes;

extern const struct BSTeamMORelationships {
	__unsafe_unretained NSString *followers;
	__unsafe_unretained NSString *highlights;
	__unsafe_unretained NSString *members;
	__unsafe_unretained NSString *recent_highlights;
	__unsafe_unretained NSString *sports;
} BSTeamMORelationships;

@class BSUserMO;
@class BSHighlightMO;
@class BSUserMO;
@class BSHighlightMO;
@class BSSportMO;

@interface BSTeamMOID : NSManagedObjectID {}
@end

@interface _BSTeamMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSTeamMOID* objectID;

@property (nonatomic, strong) NSString* avatar_url;

//- (BOOL)validateAvatar_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cover_url;

//- (BOOL)validateCover_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* creator_id;

@property (atomic) int64_t creator_idValue;
- (int64_t)creator_idValue;
- (void)setCreator_idValue:(int64_t)value_;

//- (BOOL)validateCreator_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* followers_count;

@property (atomic) int32_t followers_countValue;
- (int32_t)followers_countValue;
- (void)setFollowers_countValue:(int32_t)value_;

//- (BOOL)validateFollowers_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* highlights_count;

@property (atomic) int32_t highlights_countValue;
- (int32_t)highlights_countValue;
- (void)setHighlights_countValue:(int32_t)value_;

//- (BOOL)validateHighlights_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_applying;

@property (atomic) BOOL is_applyingValue;
- (BOOL)is_applyingValue;
- (void)setIs_applyingValue:(BOOL)value_;

//- (BOOL)validateIs_applying:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_following;

@property (atomic) BOOL is_followingValue;
- (BOOL)is_followingValue;
- (void)setIs_followingValue:(BOOL)value_;

//- (BOOL)validateIs_following:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_invited;

@property (atomic) BOOL is_invitedValue;
- (BOOL)is_invitedValue;
- (void)setIs_invitedValue:(BOOL)value_;

//- (BOOL)validateIs_invited:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_joinable;

@property (atomic) BOOL is_joinableValue;
- (BOOL)is_joinableValue;
- (void)setIs_joinableValue:(BOOL)value_;

//- (BOOL)validateIs_joinable:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_manager;

@property (atomic) BOOL is_managerValue;
- (BOOL)is_managerValue;
- (void)setIs_managerValue:(BOOL)value_;

//- (BOOL)validateIs_manager:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_member;

@property (atomic) BOOL is_memberValue;
- (BOOL)is_memberValue;
- (void)setIs_memberValue:(BOOL)value_;

//- (BOOL)validateIs_member:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_private;

@property (atomic) BOOL is_privateValue;
- (BOOL)is_privateValue;
- (void)setIs_privateValue:(BOOL)value_;

//- (BOOL)validateIs_private:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* members_count;

@property (atomic) int32_t members_countValue;
- (int32_t)members_countValue;
- (void)setMembers_countValue:(int32_t)value_;

//- (BOOL)validateMembers_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updated_at;

//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *followers;

- (NSMutableSet*)followersSet;

@property (nonatomic, strong) NSSet *highlights;

- (NSMutableSet*)highlightsSet;

@property (nonatomic, strong) NSSet *members;

- (NSMutableSet*)membersSet;

@property (nonatomic, strong) NSSet *recent_highlights;

- (NSMutableSet*)recent_highlightsSet;

@property (nonatomic, strong) NSSet *sports;

- (NSMutableSet*)sportsSet;

@end

@interface _BSTeamMO (FollowersCoreDataGeneratedAccessors)
- (void)addFollowers:(NSSet*)value_;
- (void)removeFollowers:(NSSet*)value_;
- (void)addFollowersObject:(BSUserMO*)value_;
- (void)removeFollowersObject:(BSUserMO*)value_;

@end

@interface _BSTeamMO (HighlightsCoreDataGeneratedAccessors)
- (void)addHighlights:(NSSet*)value_;
- (void)removeHighlights:(NSSet*)value_;
- (void)addHighlightsObject:(BSHighlightMO*)value_;
- (void)removeHighlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSTeamMO (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet*)value_;
- (void)removeMembers:(NSSet*)value_;
- (void)addMembersObject:(BSUserMO*)value_;
- (void)removeMembersObject:(BSUserMO*)value_;

@end

@interface _BSTeamMO (Recent_highlightsCoreDataGeneratedAccessors)
- (void)addRecent_highlights:(NSSet*)value_;
- (void)removeRecent_highlights:(NSSet*)value_;
- (void)addRecent_highlightsObject:(BSHighlightMO*)value_;
- (void)removeRecent_highlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSTeamMO (SportsCoreDataGeneratedAccessors)
- (void)addSports:(NSSet*)value_;
- (void)removeSports:(NSSet*)value_;
- (void)addSportsObject:(BSSportMO*)value_;
- (void)removeSportsObject:(BSSportMO*)value_;

@end

@interface _BSTeamMO (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAvatar_url;
- (void)setPrimitiveAvatar_url:(NSString*)value;

- (NSString*)primitiveCover_url;
- (void)setPrimitiveCover_url:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSNumber*)primitiveCreator_id;
- (void)setPrimitiveCreator_id:(NSNumber*)value;

- (int64_t)primitiveCreator_idValue;
- (void)setPrimitiveCreator_idValue:(int64_t)value_;

- (NSNumber*)primitiveFollowers_count;
- (void)setPrimitiveFollowers_count:(NSNumber*)value;

- (int32_t)primitiveFollowers_countValue;
- (void)setPrimitiveFollowers_countValue:(int32_t)value_;

- (NSNumber*)primitiveHighlights_count;
- (void)setPrimitiveHighlights_count:(NSNumber*)value;

- (int32_t)primitiveHighlights_countValue;
- (void)setPrimitiveHighlights_countValue:(int32_t)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveIs_applying;
- (void)setPrimitiveIs_applying:(NSNumber*)value;

- (BOOL)primitiveIs_applyingValue;
- (void)setPrimitiveIs_applyingValue:(BOOL)value_;

- (NSNumber*)primitiveIs_following;
- (void)setPrimitiveIs_following:(NSNumber*)value;

- (BOOL)primitiveIs_followingValue;
- (void)setPrimitiveIs_followingValue:(BOOL)value_;

- (NSNumber*)primitiveIs_invited;
- (void)setPrimitiveIs_invited:(NSNumber*)value;

- (BOOL)primitiveIs_invitedValue;
- (void)setPrimitiveIs_invitedValue:(BOOL)value_;

- (NSNumber*)primitiveIs_joinable;
- (void)setPrimitiveIs_joinable:(NSNumber*)value;

- (BOOL)primitiveIs_joinableValue;
- (void)setPrimitiveIs_joinableValue:(BOOL)value_;

- (NSNumber*)primitiveIs_manager;
- (void)setPrimitiveIs_manager:(NSNumber*)value;

- (BOOL)primitiveIs_managerValue;
- (void)setPrimitiveIs_managerValue:(BOOL)value_;

- (NSNumber*)primitiveIs_member;
- (void)setPrimitiveIs_member:(NSNumber*)value;

- (BOOL)primitiveIs_memberValue;
- (void)setPrimitiveIs_memberValue:(BOOL)value_;

- (NSNumber*)primitiveIs_private;
- (void)setPrimitiveIs_private:(NSNumber*)value;

- (BOOL)primitiveIs_privateValue;
- (void)setPrimitiveIs_privateValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;

- (NSNumber*)primitiveMembers_count;
- (void)setPrimitiveMembers_count:(NSNumber*)value;

- (int32_t)primitiveMembers_countValue;
- (void)setPrimitiveMembers_countValue:(int32_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;

- (NSMutableSet*)primitiveFollowers;
- (void)setPrimitiveFollowers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveHighlights;
- (void)setPrimitiveHighlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRecent_highlights;
- (void)setPrimitiveRecent_highlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSports;
- (void)setPrimitiveSports:(NSMutableSet*)value;

@end
