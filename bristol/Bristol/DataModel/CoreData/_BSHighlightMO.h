// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSHighlightMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSHighlightMOAttributes {
	__unsafe_unretained NSString *comments_count;
	__unsafe_unretained NSString *cover_url;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *frame_rate;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *is_can_comment;
	__unsafe_unretained NSString *is_liked;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *likes_count;
	__unsafe_unretained NSString *local_cover_path;
	__unsafe_unretained NSString *local_identifier;
	__unsafe_unretained NSString *local_index_in_feed;
	__unsafe_unretained NSString *local_is_feed_highlight;
	__unsafe_unretained NSString *local_is_wait_for_post;
	__unsafe_unretained NSString *local_share_types;
	__unsafe_unretained NSString *local_share_url;
	__unsafe_unretained NSString *local_video_path;
	__unsafe_unretained NSString *location_name;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *loop_velocity;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *played_times;
	__unsafe_unretained NSString *shoot_at;
	__unsafe_unretained NSString *sport_type;
	__unsafe_unretained NSString *thumbnail_url;
	__unsafe_unretained NSString *video_size;
	__unsafe_unretained NSString *video_url;
	__unsafe_unretained NSString *watched_users;
} BSHighlightMOAttributes;

extern const struct BSHighlightMORelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *event;
	__unsafe_unretained NSString *sport;
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *user;
} BSHighlightMORelationships;

@class BSCommentMO;
@class BSEventMO;
@class BSSportMO;
@class BSTeamMO;
@class BSUserMO;

@interface BSHighlightMOID : NSManagedObjectID {}
@end

@interface _BSHighlightMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSHighlightMOID* objectID;

@property (nonatomic, strong) NSNumber* comments_count;

@property (atomic) int32_t comments_countValue;
- (int32_t)comments_countValue;
- (void)setComments_countValue:(int32_t)value_;

//- (BOOL)validateComments_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cover_url;

//- (BOOL)validateCover_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* duration;

@property (atomic) int16_t durationValue;
- (int16_t)durationValue;
- (void)setDurationValue:(int16_t)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* frame_rate;

@property (atomic) float frame_rateValue;
- (float)frame_rateValue;
- (void)setFrame_rateValue:(float)value_;

//- (BOOL)validateFrame_rate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_can_comment;

@property (atomic) BOOL is_can_commentValue;
- (BOOL)is_can_commentValue;
- (void)setIs_can_commentValue:(BOOL)value_;

//- (BOOL)validateIs_can_comment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_liked;

@property (atomic) BOOL is_likedValue;
- (BOOL)is_likedValue;
- (void)setIs_likedValue:(BOOL)value_;

//- (BOOL)validateIs_liked:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* likes_count;

@property (atomic) int32_t likes_countValue;
- (int32_t)likes_countValue;
- (void)setLikes_countValue:(int32_t)value_;

//- (BOOL)validateLikes_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* local_cover_path;

//- (BOOL)validateLocal_cover_path:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_identifier;

@property (atomic) int64_t local_identifierValue;
- (int64_t)local_identifierValue;
- (void)setLocal_identifierValue:(int64_t)value_;

//- (BOOL)validateLocal_identifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_index_in_feed;

@property (atomic) int16_t local_index_in_feedValue;
- (int16_t)local_index_in_feedValue;
- (void)setLocal_index_in_feedValue:(int16_t)value_;

//- (BOOL)validateLocal_index_in_feed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_is_feed_highlight;

@property (atomic) BOOL local_is_feed_highlightValue;
- (BOOL)local_is_feed_highlightValue;
- (void)setLocal_is_feed_highlightValue:(BOOL)value_;

//- (BOOL)validateLocal_is_feed_highlight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_is_wait_for_post;

@property (atomic) BOOL local_is_wait_for_postValue;
- (BOOL)local_is_wait_for_postValue;
- (void)setLocal_is_wait_for_postValue:(BOOL)value_;

//- (BOOL)validateLocal_is_wait_for_post:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* local_share_types;

//- (BOOL)validateLocal_share_types:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* local_share_url;

//- (BOOL)validateLocal_share_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* local_video_path;

//- (BOOL)validateLocal_video_path:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location_name;

//- (BOOL)validateLocation_name:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* loop_velocity;

@property (atomic) float loop_velocityValue;
- (float)loop_velocityValue;
- (void)setLoop_velocityValue:(float)value_;

//- (BOOL)validateLoop_velocity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* message;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* played_times;

@property (atomic) int32_t played_timesValue;
- (int32_t)played_timesValue;
- (void)setPlayed_timesValue:(int32_t)value_;

//- (BOOL)validatePlayed_times:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* shoot_at;

//- (BOOL)validateShoot_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sport_type;

@property (atomic) int16_t sport_typeValue;
- (int16_t)sport_typeValue;
- (void)setSport_typeValue:(int16_t)value_;

//- (BOOL)validateSport_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* thumbnail_url;

//- (BOOL)validateThumbnail_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* video_size;

@property (atomic) int16_t video_sizeValue;
- (int16_t)video_sizeValue;
- (void)setVideo_sizeValue:(int16_t)value_;

//- (BOOL)validateVideo_size:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* video_url;

//- (BOOL)validateVideo_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* watched_users;

@property (atomic) int32_t watched_usersValue;
- (int32_t)watched_usersValue;
- (void)setWatched_usersValue:(int32_t)value_;

//- (BOOL)validateWatched_users:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *comments;

- (NSMutableSet*)commentsSet;

@property (nonatomic, strong) BSEventMO *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSSportMO *sport;

//- (BOOL)validateSport:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSTeamMO *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BSUserMO *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _BSHighlightMO (CommentsCoreDataGeneratedAccessors)
- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(BSCommentMO*)value_;
- (void)removeCommentsObject:(BSCommentMO*)value_;

@end

@interface _BSHighlightMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveComments_count;
- (void)setPrimitiveComments_count:(NSNumber*)value;

- (int32_t)primitiveComments_countValue;
- (void)setPrimitiveComments_countValue:(int32_t)value_;

- (NSString*)primitiveCover_url;
- (void)setPrimitiveCover_url:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (int16_t)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(int16_t)value_;

- (NSNumber*)primitiveFrame_rate;
- (void)setPrimitiveFrame_rate:(NSNumber*)value;

- (float)primitiveFrame_rateValue;
- (void)setPrimitiveFrame_rateValue:(float)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveIs_can_comment;
- (void)setPrimitiveIs_can_comment:(NSNumber*)value;

- (BOOL)primitiveIs_can_commentValue;
- (void)setPrimitiveIs_can_commentValue:(BOOL)value_;

- (NSNumber*)primitiveIs_liked;
- (void)setPrimitiveIs_liked:(NSNumber*)value;

- (BOOL)primitiveIs_likedValue;
- (void)setPrimitiveIs_likedValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;

- (NSNumber*)primitiveLikes_count;
- (void)setPrimitiveLikes_count:(NSNumber*)value;

- (int32_t)primitiveLikes_countValue;
- (void)setPrimitiveLikes_countValue:(int32_t)value_;

- (NSString*)primitiveLocal_cover_path;
- (void)setPrimitiveLocal_cover_path:(NSString*)value;

- (NSNumber*)primitiveLocal_identifier;
- (void)setPrimitiveLocal_identifier:(NSNumber*)value;

- (int64_t)primitiveLocal_identifierValue;
- (void)setPrimitiveLocal_identifierValue:(int64_t)value_;

- (NSNumber*)primitiveLocal_index_in_feed;
- (void)setPrimitiveLocal_index_in_feed:(NSNumber*)value;

- (int16_t)primitiveLocal_index_in_feedValue;
- (void)setPrimitiveLocal_index_in_feedValue:(int16_t)value_;

- (NSNumber*)primitiveLocal_is_feed_highlight;
- (void)setPrimitiveLocal_is_feed_highlight:(NSNumber*)value;

- (BOOL)primitiveLocal_is_feed_highlightValue;
- (void)setPrimitiveLocal_is_feed_highlightValue:(BOOL)value_;

- (NSNumber*)primitiveLocal_is_wait_for_post;
- (void)setPrimitiveLocal_is_wait_for_post:(NSNumber*)value;

- (BOOL)primitiveLocal_is_wait_for_postValue;
- (void)setPrimitiveLocal_is_wait_for_postValue:(BOOL)value_;

- (NSString*)primitiveLocal_share_types;
- (void)setPrimitiveLocal_share_types:(NSString*)value;

- (NSString*)primitiveLocal_share_url;
- (void)setPrimitiveLocal_share_url:(NSString*)value;

- (NSString*)primitiveLocal_video_path;
- (void)setPrimitiveLocal_video_path:(NSString*)value;

- (NSString*)primitiveLocation_name;
- (void)setPrimitiveLocation_name:(NSString*)value;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;

- (NSNumber*)primitiveLoop_velocity;
- (void)setPrimitiveLoop_velocity:(NSNumber*)value;

- (float)primitiveLoop_velocityValue;
- (void)setPrimitiveLoop_velocityValue:(float)value_;

- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;

- (NSNumber*)primitivePlayed_times;
- (void)setPrimitivePlayed_times:(NSNumber*)value;

- (int32_t)primitivePlayed_timesValue;
- (void)setPrimitivePlayed_timesValue:(int32_t)value_;

- (NSDate*)primitiveShoot_at;
- (void)setPrimitiveShoot_at:(NSDate*)value;

- (NSNumber*)primitiveSport_type;
- (void)setPrimitiveSport_type:(NSNumber*)value;

- (int16_t)primitiveSport_typeValue;
- (void)setPrimitiveSport_typeValue:(int16_t)value_;

- (NSString*)primitiveThumbnail_url;
- (void)setPrimitiveThumbnail_url:(NSString*)value;

- (NSNumber*)primitiveVideo_size;
- (void)setPrimitiveVideo_size:(NSNumber*)value;

- (int16_t)primitiveVideo_sizeValue;
- (void)setPrimitiveVideo_sizeValue:(int16_t)value_;

- (NSString*)primitiveVideo_url;
- (void)setPrimitiveVideo_url:(NSString*)value;

- (NSNumber*)primitiveWatched_users;
- (void)setPrimitiveWatched_users:(NSNumber*)value;

- (int32_t)primitiveWatched_usersValue;
- (void)setPrimitiveWatched_usersValue:(int32_t)value_;

- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;

- (BSEventMO*)primitiveEvent;
- (void)setPrimitiveEvent:(BSEventMO*)value;

- (BSSportMO*)primitiveSport;
- (void)setPrimitiveSport:(BSSportMO*)value;

- (BSTeamMO*)primitiveTeam;
- (void)setPrimitiveTeam:(BSTeamMO*)value;

- (BSUserMO*)primitiveUser;
- (void)setPrimitiveUser:(BSUserMO*)value;

@end
