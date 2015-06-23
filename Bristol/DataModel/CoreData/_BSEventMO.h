// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSEventMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSEventMOAttributes {
	__unsafe_unretained NSString *avatar_url;
	__unsafe_unretained NSString *cover_url;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *end_time;
	__unsafe_unretained NSString *followers_count;
	__unsafe_unretained NSString *highlights_count;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *is_active;
	__unsafe_unretained NSString *is_following;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *recommend_description;
	__unsafe_unretained NSString *start_time;
} BSEventMOAttributes;

extern const struct BSEventMORelationships {
	__unsafe_unretained NSString *followers;
	__unsafe_unretained NSString *highlights;
	__unsafe_unretained NSString *recent_followers;
	__unsafe_unretained NSString *recent_highlights;
} BSEventMORelationships;

@class BSUserMO;
@class BSHighlightMO;
@class BSUserMO;
@class BSHighlightMO;

@interface BSEventMOID : NSManagedObjectID {}
@end

@interface _BSEventMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSEventMOID* objectID;

@property (nonatomic, strong) NSString* avatar_url;

//- (BOOL)validateAvatar_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cover_url;

//- (BOOL)validateCover_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* end_time;

//- (BOOL)validateEnd_time:(id*)value_ error:(NSError**)error_;

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

@property (nonatomic, strong) NSNumber* is_active;

@property (atomic) BOOL is_activeValue;
- (BOOL)is_activeValue;
- (void)setIs_activeValue:(BOOL)value_;

//- (BOOL)validateIs_active:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_following;

@property (atomic) BOOL is_followingValue;
- (BOOL)is_followingValue;
- (void)setIs_followingValue:(BOOL)value_;

//- (BOOL)validateIs_following:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* recommend_description;

//- (BOOL)validateRecommend_description:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* start_time;

//- (BOOL)validateStart_time:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *followers;

- (NSMutableSet*)followersSet;

@property (nonatomic, strong) NSSet *highlights;

- (NSMutableSet*)highlightsSet;

@property (nonatomic, strong) NSSet *recent_followers;

- (NSMutableSet*)recent_followersSet;

@property (nonatomic, strong) NSSet *recent_highlights;

- (NSMutableSet*)recent_highlightsSet;

@end

@interface _BSEventMO (FollowersCoreDataGeneratedAccessors)
- (void)addFollowers:(NSSet*)value_;
- (void)removeFollowers:(NSSet*)value_;
- (void)addFollowersObject:(BSUserMO*)value_;
- (void)removeFollowersObject:(BSUserMO*)value_;

@end

@interface _BSEventMO (HighlightsCoreDataGeneratedAccessors)
- (void)addHighlights:(NSSet*)value_;
- (void)removeHighlights:(NSSet*)value_;
- (void)addHighlightsObject:(BSHighlightMO*)value_;
- (void)removeHighlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSEventMO (Recent_followersCoreDataGeneratedAccessors)
- (void)addRecent_followers:(NSSet*)value_;
- (void)removeRecent_followers:(NSSet*)value_;
- (void)addRecent_followersObject:(BSUserMO*)value_;
- (void)removeRecent_followersObject:(BSUserMO*)value_;

@end

@interface _BSEventMO (Recent_highlightsCoreDataGeneratedAccessors)
- (void)addRecent_highlights:(NSSet*)value_;
- (void)removeRecent_highlights:(NSSet*)value_;
- (void)addRecent_highlightsObject:(BSHighlightMO*)value_;
- (void)removeRecent_highlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSEventMO (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAvatar_url;
- (void)setPrimitiveAvatar_url:(NSString*)value;

- (NSString*)primitiveCover_url;
- (void)setPrimitiveCover_url:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSDate*)primitiveEnd_time;
- (void)setPrimitiveEnd_time:(NSDate*)value;

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

- (NSNumber*)primitiveIs_active;
- (void)setPrimitiveIs_active:(NSNumber*)value;

- (BOOL)primitiveIs_activeValue;
- (void)setPrimitiveIs_activeValue:(BOOL)value_;

- (NSNumber*)primitiveIs_following;
- (void)setPrimitiveIs_following:(NSNumber*)value;

- (BOOL)primitiveIs_followingValue;
- (void)setPrimitiveIs_followingValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveRecommend_description;
- (void)setPrimitiveRecommend_description:(NSString*)value;

- (NSDate*)primitiveStart_time;
- (void)setPrimitiveStart_time:(NSDate*)value;

- (NSMutableSet*)primitiveFollowers;
- (void)setPrimitiveFollowers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveHighlights;
- (void)setPrimitiveHighlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRecent_followers;
- (void)setPrimitiveRecent_followers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRecent_highlights;
- (void)setPrimitiveRecent_highlights:(NSMutableSet*)value;

@end
