//
//  Bristol.h
//  Bristol
//
//  Created by Bo on 1/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#ifndef Bristol_Bristol_h
#define Bristol_Bristol_h

// server constants: http://bristol-test.zepp.com/api/b1/dev/constants
#define DataModelIdType int64_t

#define ZPLocalizedString(str) NSLocalizedString(str, str)
#define UserDefaults ([NSUserDefaults standardUserDefaults])

#define kDidSetCurrentUserNotification @"kDidSetCurrentUserNotification"
#define kUserDidLogoutNotification @"kUserDidLogoutNotification"
#define kUserDidLoginNotification @"kUserDidLoginNotification"

#define kHighlightDidEnqueueToPostNotification @"kHighlightDidEnqueueToPostNotification"
#define kHighlightDidPostedNotification @"kHighlightDidPostedNotification"
#define kHighlightDidRemovedNotification @"kHighlightDidRemovedNotification"

#define kFeedConfigurationDidChangedNotification @"kFeedConfigurationDidChangedNotification"
#define kHighlightLikeDidLikedNotification @"kHighlightLikeDidLikedNotification"
#define kHighlightLikeDidChangedNotification @"kHighlightLikeDidChangedNotification"
#define kHighlightDoubleTappedNotification @"kHighlightDoubleTappedNotification"
#define kHighlightShareTypeFacebook @"facebook"
#define kHighlightShareTypeTwitter @"twitter"
#define kHighlightShareTypeInstagram @"instagram"

#define kEventProfileDidShownNotification @"kEventProfileDidShownNotification"

#define kTeamProfileDidShownNotification @"kTeamProfileDidShownNotification"
#define kTeamDidAddedNotification @"kTeamDidAddedNotification"
#define kTeamDidRemovedNotification @"kTeamDidRemovedNotification"

#define kCommentDidPostedNotification @"kCommentDidPostedNotification"
#define kAvatarDidUpdatedNotification @"kAvatarDidUpdatedNotification"
#define kFollowStateDidChangedNotification @"kFollowStateDidChangedNotification"

#define kSettingsPrivacyAllowComments @"kSettingsPrivacyAllowComments"
#define kFirstLoginDate @"kFirstLoginDate"
#define kFirstAddSportsDate @"kFirstAddSportsDate"
#define kFirstAddFriendsDate @"kFirstAddFriendsDate"
#define kFirstCaptureDate @"kFirstCaptureDate"
#define kFirstCreateTeamDate @"kFirstCreateTeamDate"
#define kDraftData @"kDraftData"

#define kFeedAutoPlayVideo @"auto_play_video"
#define kFeedAutoPlayAudio @"auto_play_audio"
#define kFeedLoopingVideo @"loop_video"
#define kFeedTapToFullscreen @"tap_to_fullscreen"

#define kShowHighlightWhenTapDown (YES)
#define kClearEmptyTableViewFooterSeperator (NO)

#define kRenderedVideoSize (CGSizeMake(480, 480))
#define kRenderedVideoDuration (15.)
#define kRenderedVideoFrameRate (30.)

#define kInvalidCoordinate (400)
#define kDataCountInOnePage (24)
#define kHighlightCellColumnCount 3
#define kVideoUploadDownloadTimeout (1 * 60)
#define DeviceMainScreenSize [[UIScreen mainScreen] bounds].size

#define kToastMininumInterval 3
#define kErrorMininumInterval 10

static NSString *const OverwriteRequiredMessage = @"overwrite is required for sub class";
static NSString *const UnitTestEmailDomain = @"dev.ios.testemail";

typedef void (^ZPFloatBlock) (float value);
typedef void (^ZPIntBlock) (int value);

typedef NS_ENUM (NSUInteger, BSToptenChannelType) {
	BSToptenChannelTypeFriends = 1,
	BSToptenChannelTypeSports,
	BSToptenChannelTypeEvents,
};

#endif
