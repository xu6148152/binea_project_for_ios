// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BSUserMO.h instead.

#import <CoreData/CoreData.h>

extern const struct BSUserMOAttributes {
	__unsafe_unretained NSString *allow_comments;
	__unsafe_unretained NSString *avatar_url;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *events_count;
	__unsafe_unretained NSString *followers_count;
	__unsafe_unretained NSString *following_count;
	__unsafe_unretained NSString *highlights_count;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *is_following;
	__unsafe_unretained NSString *is_public;
	__unsafe_unretained NSString *large_avatar_url;
	__unsafe_unretained NSString *local_is_sending_follow_request;
	__unsafe_unretained NSString *name_human_readable;
	__unsafe_unretained NSString *name_id;
	__unsafe_unretained NSString *sport_type;
	__unsafe_unretained NSString *teams_count;
	__unsafe_unretained NSString *thumbnail_url;
	__unsafe_unretained NSString *video_url;
} BSUserMOAttributes;

extern const struct BSUserMORelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *events;
	__unsafe_unretained NSString *followed_teams;
	__unsafe_unretained NSString *highlights;
	__unsafe_unretained NSString *joined_teams;
	__unsafe_unretained NSString *recent_highlights;
	__unsafe_unretained NSString *sports;
} BSUserMORelationships;

@class BSCommentMO;
@class BSEventMO;
@class BSTeamMO;
@class BSHighlightMO;
@class BSTeamMO;
@class BSHighlightMO;
@class BSSportMO;

@interface BSUserMOID : NSManagedObjectID {}
@end

@interface _BSUserMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BSUserMOID* objectID;

@property (nonatomic, strong) NSNumber* allow_comments;

@property (atomic) int16_t allow_commentsValue;
- (int16_t)allow_commentsValue;
- (void)setAllow_commentsValue:(int16_t)value_;

//- (BOOL)validateAllow_comments:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* avatar_url;

//- (BOOL)validateAvatar_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* events_count;

@property (atomic) int64_t events_countValue;
- (int64_t)events_countValue;
- (void)setEvents_countValue:(int64_t)value_;

//- (BOOL)validateEvents_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* followers_count;

@property (atomic) int64_t followers_countValue;
- (int64_t)followers_countValue;
- (void)setFollowers_countValue:(int64_t)value_;

//- (BOOL)validateFollowers_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* following_count;

@property (atomic) int64_t following_countValue;
- (int64_t)following_countValue;
- (void)setFollowing_countValue:(int64_t)value_;

//- (BOOL)validateFollowing_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* highlights_count;

@property (atomic) int64_t highlights_countValue;
- (int64_t)highlights_countValue;
- (void)setHighlights_countValue:(int64_t)value_;

//- (BOOL)validateHighlights_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_following;

@property (atomic) BOOL is_followingValue;
- (BOOL)is_followingValue;
- (void)setIs_followingValue:(BOOL)value_;

//- (BOOL)validateIs_following:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_public;

@property (atomic) BOOL is_publicValue;
- (BOOL)is_publicValue;
- (void)setIs_publicValue:(BOOL)value_;

//- (BOOL)validateIs_public:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* large_avatar_url;

//- (BOOL)validateLarge_avatar_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_is_sending_follow_request;

@property (atomic) BOOL local_is_sending_follow_requestValue;
- (BOOL)local_is_sending_follow_requestValue;
- (void)setLocal_is_sending_follow_requestValue:(BOOL)value_;

//- (BOOL)validateLocal_is_sending_follow_request:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name_human_readable;

//- (BOOL)validateName_human_readable:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name_id;

//- (BOOL)validateName_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sport_type;

@property (atomic) int32_t sport_typeValue;
- (int32_t)sport_typeValue;
- (void)setSport_typeValue:(int32_t)value_;

//- (BOOL)validateSport_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* teams_count;

@property (atomic) int64_t teams_countValue;
- (int64_t)teams_countValue;
- (void)setTeams_countValue:(int64_t)value_;

//- (BOOL)validateTeams_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* thumbnail_url;

//- (BOOL)validateThumbnail_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* video_url;

//- (BOOL)validateVideo_url:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *comments;

- (NSMutableSet*)commentsSet;

@property (nonatomic, strong) NSSet *events;

- (NSMutableSet*)eventsSet;

@property (nonatomic, strong) NSSet *followed_teams;

- (NSMutableSet*)followed_teamsSet;

@property (nonatomic, strong) NSSet *highlights;

- (NSMutableSet*)highlightsSet;

@property (nonatomic, strong) NSSet *joined_teams;

- (NSMutableSet*)joined_teamsSet;

@property (nonatomic, strong) NSSet *recent_highlights;

- (NSMutableSet*)recent_highlightsSet;

@property (nonatomic, strong) NSSet *sports;

- (NSMutableSet*)sportsSet;

@end

@interface _BSUserMO (CommentsCoreDataGeneratedAccessors)
- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(BSCommentMO*)value_;
- (void)removeCommentsObject:(BSCommentMO*)value_;

@end

@interface _BSUserMO (EventsCoreDataGeneratedAccessors)
- (void)addEvents:(NSSet*)value_;
- (void)removeEvents:(NSSet*)value_;
- (void)addEventsObject:(BSEventMO*)value_;
- (void)removeEventsObject:(BSEventMO*)value_;

@end

@interface _BSUserMO (Followed_teamsCoreDataGeneratedAccessors)
- (void)addFollowed_teams:(NSSet*)value_;
- (void)removeFollowed_teams:(NSSet*)value_;
- (void)addFollowed_teamsObject:(BSTeamMO*)value_;
- (void)removeFollowed_teamsObject:(BSTeamMO*)value_;

@end

@interface _BSUserMO (HighlightsCoreDataGeneratedAccessors)
- (void)addHighlights:(NSSet*)value_;
- (void)removeHighlights:(NSSet*)value_;
- (void)addHighlightsObject:(BSHighlightMO*)value_;
- (void)removeHighlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSUserMO (Joined_teamsCoreDataGeneratedAccessors)
- (void)addJoined_teams:(NSSet*)value_;
- (void)removeJoined_teams:(NSSet*)value_;
- (void)addJoined_teamsObject:(BSTeamMO*)value_;
- (void)removeJoined_teamsObject:(BSTeamMO*)value_;

@end

@interface _BSUserMO (Recent_highlightsCoreDataGeneratedAccessors)
- (void)addRecent_highlights:(NSSet*)value_;
- (void)removeRecent_highlights:(NSSet*)value_;
- (void)addRecent_highlightsObject:(BSHighlightMO*)value_;
- (void)removeRecent_highlightsObject:(BSHighlightMO*)value_;

@end

@interface _BSUserMO (SportsCoreDataGeneratedAccessors)
- (void)addSports:(NSSet*)value_;
- (void)removeSports:(NSSet*)value_;
- (void)addSportsObject:(BSSportMO*)value_;
- (void)removeSportsObject:(BSSportMO*)value_;

@end

@interface _BSUserMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAllow_comments;
- (void)setPrimitiveAllow_comments:(NSNumber*)value;

- (int16_t)primitiveAllow_commentsValue;
- (void)setPrimitiveAllow_commentsValue:(int16_t)value_;

- (NSString*)primitiveAvatar_url;
- (void)setPrimitiveAvatar_url:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveEvents_count;
- (void)setPrimitiveEvents_count:(NSNumber*)value;

- (int64_t)primitiveEvents_countValue;
- (void)setPrimitiveEvents_countValue:(int64_t)value_;

- (NSNumber*)primitiveFollowers_count;
- (void)setPrimitiveFollowers_count:(NSNumber*)value;

- (int64_t)primitiveFollowers_countValue;
- (void)setPrimitiveFollowers_countValue:(int64_t)value_;

- (NSNumber*)primitiveFollowing_count;
- (void)setPrimitiveFollowing_count:(NSNumber*)value;

- (int64_t)primitiveFollowing_countValue;
- (void)setPrimitiveFollowing_countValue:(int64_t)value_;

- (NSNumber*)primitiveHighlights_count;
- (void)setPrimitiveHighlights_count:(NSNumber*)value;

- (int64_t)primitiveHighlights_countValue;
- (void)setPrimitiveHighlights_countValue:(int64_t)value_;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSNumber*)primitiveIs_following;
- (void)setPrimitiveIs_following:(NSNumber*)value;

- (BOOL)primitiveIs_followingValue;
- (void)setPrimitiveIs_followingValue:(BOOL)value_;

- (NSNumber*)primitiveIs_public;
- (void)setPrimitiveIs_public:(NSNumber*)value;

- (BOOL)primitiveIs_publicValue;
- (void)setPrimitiveIs_publicValue:(BOOL)value_;

- (NSString*)primitiveLarge_avatar_url;
- (void)setPrimitiveLarge_avatar_url:(NSString*)value;

- (NSNumber*)primitiveLocal_is_sending_follow_request;
- (void)setPrimitiveLocal_is_sending_follow_request:(NSNumber*)value;

- (BOOL)primitiveLocal_is_sending_follow_requestValue;
- (void)setPrimitiveLocal_is_sending_follow_requestValue:(BOOL)value_;

- (NSString*)primitiveName_human_readable;
- (void)setPrimitiveName_human_readable:(NSString*)value;

- (NSString*)primitiveName_id;
- (void)setPrimitiveName_id:(NSString*)value;

- (NSNumber*)primitiveSport_type;
- (void)setPrimitiveSport_type:(NSNumber*)value;

- (int32_t)primitiveSport_typeValue;
- (void)setPrimitiveSport_typeValue:(int32_t)value_;

- (NSNumber*)primitiveTeams_count;
- (void)setPrimitiveTeams_count:(NSNumber*)value;

- (int64_t)primitiveTeams_countValue;
- (void)setPrimitiveTeams_countValue:(int64_t)value_;

- (NSString*)primitiveThumbnail_url;
- (void)setPrimitiveThumbnail_url:(NSString*)value;

- (NSString*)primitiveVideo_url;
- (void)setPrimitiveVideo_url:(NSString*)value;

- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;

- (NSMutableSet*)primitiveEvents;
- (void)setPrimitiveEvents:(NSMutableSet*)value;

- (NSMutableSet*)primitiveFollowed_teams;
- (void)setPrimitiveFollowed_teams:(NSMutableSet*)value;

- (NSMutableSet*)primitiveHighlights;
- (void)setPrimitiveHighlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveJoined_teams;
- (void)setPrimitiveJoined_teams:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRecent_highlights;
- (void)setPrimitiveRecent_highlights:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSports;
- (void)setPrimitiveSports:(NSMutableSet*)value;

@end
