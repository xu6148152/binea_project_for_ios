//
//  ZPDataManager.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataManager.h"
#import "BSDataModels.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^BSHighlightBlock) (BSHighlightMO *highlight);


@interface BSDataManager : ZPBaseDataManager

@property (nonatomic, strong, readonly) NSArray *songsAvailable; // list of BSSongDataModel entities
@property (nonatomic, strong, readonly) NSArray *recentCreatedLocations;
@property (nonatomic, strong, readonly) BSUserMO *currentUser;

- (void)saveCookie;
- (void)logOut;

// user
- (void)setCurrentUserWithId:(NSNumber *)identifier;
- (void)updateLocalAvatarWithImage:(UIImage *)image;

// highlight
- (NSArray *)getCachedFeedHighlights;
- (NSArray *)getLocalHighlightsForPost;

- (NSString *)getVideoFullPath;
- (NSString *)getVideoFullPathForHighlight:(BSHighlightMO *)highlight;
- (BOOL)isVideoDownloadedForHighlight:(BSHighlightMO *)highlight;
- (void)cancelVideoDownloadingForHighlight:(BSHighlightMO *)highlight;
- (void)downloadVideoForHighlight:(BSHighlightMO *)highlight progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild;
- (AVURLAsset *)streamVideoForHighlight:(BSHighlightMO *)highlight progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild;

// post
- (void)postHighlightWithMessage:(NSString *)message coordinate:(CLLocationCoordinate2D)coordinate locationName:(NSString *)locationName sportType:(NSUInteger)sportType localCoverPath:(NSString *)localCoverPath localVideoPath:(NSString *)localVideoPath shootAt:(NSDate *)shootAt shareTypes:(NSString *)shareTypes event:(BSEventMO *)event team:(BSTeamMO *)team;
- (void)postLocalHighlight:(BSHighlightMO *)highlight progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild;
- (BOOL)isUploadingForHighlight:(BSHighlightMO *)highlight;

// user created location
- (NSUInteger)addLocationWithName:(NSString *)name;
- (void)removeLocationWithName:(NSString *)name;

@end
