#import "_BSNotificationMO.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

// Ref: http://bristol-test.zepp.com/api/b1/dev/constants
typedef NS_ENUM(NSInteger, BSNotificationType) {
	BSNotificationTypeInvalid = 0,
	BSNotificationTypeLike,
	BSNotificationTypeMentionMeInHighlight,
	BSNotificationTypeComment, // 3
	BSNotificationTypeUserDirectToFollowMe,
	BSNotificationTypeTeamInviteMeToJoin,
	BSNotificationTypeTeamApproveJoinRequest, // 6
	BSNotificationTypeTeamSomeoneJoin,
	BSNotificationTypeSocialFriendJoined,
	BSNotificationTypeHighlightTopTen, // 9
	BSNotificationTypeMentionMeInComment,
	BSNotificationTypeUserRequestToFollowMe,
	BSNotificationTypeAcceptRequestToFollowMe, // 12
	BSNotificationTypeHelpMeTop,
};

@interface BSNotificationMO : _BSNotificationMO <ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

+ (RKMapping *)responseMappingWithFeedTimeline; // TODO: don't save this data to Notification table

- (NSString *)formatedTextForTypeHelpMeTop;

@end
