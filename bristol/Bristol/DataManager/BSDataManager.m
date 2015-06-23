//
//  ZPDataManager.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "BSDataManager.h"
#import "FXKeychain.h"
#import "SDImageCache.h"

#import "BSVideoStreamer.h"
#import "BSSignInWithEmailHttpRequest.h"
#import "BSHighlightPostHttpRequest.h"
#import "BSHighlightPostUploadVideoHttpRequest.h"

#import "BSEventTracker.h"

@interface BSDataManager ()
{
	NSMutableArray *_recentCreatedLocations;
}
@property (nonatomic, strong) NSMutableDictionary *dicVideoDownloading;
@property (nonatomic, strong) NSMutableDictionary *dicHighlightUploading;

@end

@implementation BSDataManager

const NSString *kCurrentUserId = @"CurrentUserEmail";
const NSString *kCookie = @"Cookie";
const NSUInteger kMaxHighlightsCount = kDataCountInOnePage;
NSString *TopTenAddSportsArray = @"TopTenAddSportsArray";
NSString *kVideoFolder = @"Video";
NSString *kRecentCreatedLocations = @"RecentCreatedLocations";

- (id)init {
	self = [super init];

	if (self) {
		[self _setDefault];
		[self _readData];
		[self _checkLocalDatabase];
		[self _observeReachability];
		[self save];
	}

	return self;
}

- (void)_observeReachability {
	[[RKObjectManager sharedManager].HTTPClient setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
	    switch (status) {
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				break;
			case AFNetworkReachabilityStatusNotReachable:
			default:
				break;
		}
	}];
}

- (BSSongDataModel *)_getSongDMWithFullName:(NSString *)fullName {
	if (!fullName) {
		return nil;
	}
	
	NSString *name = [fullName stringByDeletingPathExtension];
	NSString *extension = [fullName pathExtension];
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:extension]];
	BSSongDataModel *song = [BSSongDataModel songWithName:name url:url];
	
	return song;
}

- (void)_checkSportTableExistRowWithName:(NSString *)name identifier:(NSInteger)identifier {
	NSArray *ary = [BSSportMO findByAttribute:@"identifier" withValue:@(identifier)];
	if (ary.count > 0) {
		for (int i = (int)ary.count - 1; i > 0; i--) {
			BSSportMO *sport = ary[i];
			[sport deleteEntity];
		}
	}
	else {
		BSSportMO *sport = [BSSportMO createEntity];
		sport.nameKey = name;
		sport.identifier = @(identifier);
	}
}

- (void)_setDefault {
	[UserDefaults registerDefaults:@{kFeedAutoPlayVideo:@YES, kFeedAutoPlayAudio:@YES, kFeedLoopingVideo:@YES}];
	[UserDefaults synchronize];
}

- (void)_readData {
	NSNumber *identifier = [FXKeychain defaultKeychain][kCurrentUserId];
	[self setCurrentUserWithId:identifier];

	NSArray *aryCookies = [FXKeychain defaultKeychain][kCookie];
	if ([aryCookies isKindOfClass:[NSArray class]]) {
		for (NSHTTPCookie *cookie in aryCookies) {
			if ([cookie isKindOfClass:[NSHTTPCookie class]]) {
				[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
			}
		}
	}
	else {
		[[FXKeychain defaultKeychain] removeObjectForKey:kCookie];
	}

	_recentCreatedLocations = [[[NSUserDefaults standardUserDefaults] objectForKey:kRecentCreatedLocations] mutableCopy];
	if (!_recentCreatedLocations) {
		_recentCreatedLocations = [NSMutableArray array];
	}
	
	_songsAvailable = [NSArray arrayWithObjects:
					   [self _getSongDMWithFullName:@"A Great Indie Band.mp3"],
					   [self _getSongDMWithFullName:@"A Step Ahead.mp3"],
					   [self _getSongDMWithFullName:@"Accelerator.mp3"],
					   [self _getSongDMWithFullName:@"Bad Ass Hip Hop.mp3"],
					   [self _getSongDMWithFullName:@"Black Glitter.mp3"],
					   [self _getSongDMWithFullName:@"Boulangerie.mp3"],
					   [self _getSongDMWithFullName:@"Champion.mp3"],
					   nil];

	[self _checkSportTableExistRowWithName:@"Golf" identifier:1];
	[self _checkSportTableExistRowWithName:@"Baseball" identifier:2];
	[self _checkSportTableExistRowWithName:@"Tennis" identifier:3];
	[self _checkSportTableExistRowWithName:@"Softball" identifier:4];
	[self _checkSportTableExistRowWithName:@"Badminton" identifier:5];
	[self _checkSportTableExistRowWithName:@"Ping Pong" identifier:6];
	[self _checkSportTableExistRowWithName:@"Football" identifier:7];
	[self _checkSportTableExistRowWithName:@"Soccer" identifier:8];
	[self _checkSportTableExistRowWithName:@"Basketball" identifier:9];
	[self _checkSportTableExistRowWithName:@"Hockey" identifier:10];
	[self _checkSportTableExistRowWithName:@"Lacrosse" identifier:11];
	[self _checkSportTableExistRowWithName:@"Cricket" identifier:12];
	[self _checkSportTableExistRowWithName:@"Surfing" identifier:13];
	[self _checkSportTableExistRowWithName:@"Skateboarding" identifier:14];
	[self _checkSportTableExistRowWithName:@"Ski" identifier:15];
	[self _checkSportTableExistRowWithName:@"Cycling" identifier:16];
	[self _checkSportTableExistRowWithName:@"Others" identifier:0x400];
}

- (void)_checkLocalDatabase {
	NSMutableArray *highlightsFeed = [NSMutableArray array];
	NSArray *highlightsAll = [BSHighlightMO findAllSortedBy:@"local_index_in_feed" ascending:YES];
	for (BSHighlightMO *highlight in highlightsAll) {
		BOOL videoFileExist = [[NSFileManager defaultManager] fileExistsAtPath:highlight.local_video_path isDirectory:nil];
		if (highlight.local_is_wait_for_postValue && videoFileExist) {
			continue;
		}
		
		if (highlight.local_is_feed_highlightValue) {
			[highlightsFeed addObject:highlight];
		}
		else {
			[highlight deleteEntity];
		}
	}

	// remove all highlights except top 20
	for (NSUInteger i = kMaxHighlightsCount; i < highlightsFeed.count; i++) {
		BSHighlightMO *highlight = highlightsFeed[i];
		if (![highlight deleteEntity]) {
			ZPLogError(@"delete entity error: %@", highlight);
		}
	}

	// remove all users except me
	NSMutableArray *users = [[BSUserMO findAll] mutableCopy];
	for (int i = (int)users.count - 1; i >= 0; i--) {
		if (_currentUser == users[i]) {
			[users removeObjectAtIndex:i];
			break;
		}
	}
	for (BSUserMO *user in users) {
		[user deleteEntity];
	}

	// remove all these data
//	[BSCommentMO truncateAll]; //cascade delete from BSHighlightMO
	[BSEventMO truncateAll];
	[BSTeamMO truncateAll];
	[BSNotificationMO truncateAll];
}

- (void)_clearDatabase {
	[BSCommentMO truncateAll];
	[BSEventMO truncateAll];
	[BSHighlightMO truncateAll];
	[BSTeamMO truncateAll];
	[BSUserMO truncateAll];
//	[BSSportMO truncateAll]; // NOTE: don't truncate this! https://zepplabs.atlassian.net/browse/BRIS-103
	[BSNotificationMO truncateAll];

	[self save];
}

- (void)save {
	[super save];

	[[NSUserDefaults standardUserDefaults] setObject:_recentCreatedLocations forKey:kRecentCreatedLocations];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCookie {
	NSArray *aryCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	NSMutableArray *aryCookiesToSave = [NSMutableArray array];

	for (NSHTTPCookie *cookie in aryCookies) {
		if ([cookie.domain rangeOfString:@"zepp.com"].location != NSNotFound) {
			[aryCookiesToSave addObject:cookie];
		}
	}
	[[FXKeychain defaultKeychain] setObject:aryCookiesToSave forKey:kCookie];
}

- (void)logOut {
	[[RKObjectManager sharedManager].HTTPClient.operationQueue cancelAllOperations];

	[[FXKeychain defaultKeychain] removeObjectForKey:kCookie];
	[[FXKeychain defaultKeychain] removeObjectForKey:kCurrentUserId];
	[UserDefaults removeObjectForKey:kDraftData];
	_currentUser = nil;
	[BSEventTracker setUser:nil];

	[self _clearDatabase];
}

- (NSMutableDictionary *)dicVideoDownloading {
	if (!_dicVideoDownloading) {
		_dicVideoDownloading = [NSMutableDictionary dictionary];
	}
	return _dicVideoDownloading;
}

- (NSMutableDictionary *)dicHighlightUploading {
	if (!_dicHighlightUploading) {
		_dicHighlightUploading = [NSMutableDictionary dictionary];
	}
	return _dicHighlightUploading;
}

#pragma mark - User
- (void)setCurrentUserWithId:(NSNumber *)identifier {
	if (!identifier) {
		return;
	}

	if (![_currentUser.identifier isEqualToNumber:identifier]) {
		_currentUser = [BSUserMO findFirstByAttribute:@"identifier" withValue:identifier];
		if (_currentUser) {
			[BSEventTracker setUser:_currentUser];
			[[FXKeychain defaultKeychain] setObject:identifier forKey:kCurrentUserId];

			[[NSNotificationCenter defaultCenter] postNotificationName:kDidSetCurrentUserNotification object:nil];
		}
	}
}

- (void)updateLocalAvatarWithImage:(UIImage *)image {
	if (image && _currentUser) {
		[[SDImageCache sharedImageCache] removeImageForKey:_currentUser.avatar_url];
		NSString *name = [[SDImageCache sharedImageCache] performSelector:@selector(cachedFileNameForKey:) withObject:_currentUser.avatar_url];
		NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
		NSString *fullPath = [path stringByAppendingPathComponent:name];
		[UIImageJPEGRepresentation(image, .9) writeToFile:fullPath atomically:YES];
	}
}

#pragma mark - highlight
- (NSArray *)_getHighlightsWithPredicate:(NSPredicate *)predicate {
	NSArray *highlights = [BSHighlightMO findAllWithPredicate:predicate];
	highlights = [highlights sortedArrayUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
	    return [((BSHighlightMO *)obj1).created_at compare:((BSHighlightMO *)obj2).created_at];
	}];

	return highlights;
}

- (NSArray *)getCachedFeedHighlights {
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_is_wait_for_post == %@ AND local_is_feed_highlight == %@", @(NO), @(YES)];
//    return [self _getHighlightsWithPredicate:predicate];
	NSArray *highlightsFiltered = [BSHighlightMO findAllSortedBy:@"local_index_in_feed" ascending:YES];
	return highlightsFiltered;
}

- (NSArray *)getLocalHighlightsForPost {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_is_wait_for_post == %@", @(YES)];
	return [self _getHighlightsWithPredicate:predicate];
}

- (void)_skipBackupForURL:(NSURL *)url {
	/*
	NSError *error = nil;
	[url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
	if (error) {
		ZPLogError(@"_skipBackup error:%@", error);
	}*/
}

#pragma mark - video
- (NSString *)getVideoFullPath {
	static NSString *path = nil;
	if (!path) {
		path = [NSTemporaryDirectory() stringByAppendingPathComponent:kVideoFolder];
		if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSError *err = nil;
			[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
			if (err) {
				ZPLogError(@"create video folder error:%@", err);
			}
		}
	}
	return path;
}

- (NSString *)getVideoFullPathForHighlight:(BSHighlightMO *)highlight {
	return [[self getVideoFullPath] stringByAppendingPathComponent:[highlight.video_url lastPathComponent]];
}

- (BOOL)isVideoDownloadedForHighlight:(BSHighlightMO *)highlight {
	if (!highlight) {
		return NO;
	}

	NSString *path = [self getVideoFullPathForHighlight:highlight];
	if ([self.dicVideoDownloading.allKeys containsObject:path]) {
		return NO;
	}

	BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
	return exist;
}

- (void)cancelVideoDownloadingForHighlight:(BSHighlightMO *)highlight {
	if (!highlight) {
		return;
	}
	NSString *path = [self getVideoFullPathForHighlight:highlight];
	if ([self.dicVideoDownloading.allKeys containsObject:path]) {
		AFHTTPRequestOperation *operation = self.dicVideoDownloading[path][3];
		if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
			[operation cancel];
		} else {
			// TODO: cancel streaming
		}

		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
}

- (void)downloadVideoForHighlight:(BSHighlightMO *)highlight progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (!highlight) {
		return;
	}
	NSString *key = [self getVideoFullPathForHighlight:highlight];
	if ([self.dicVideoDownloading.allKeys containsObject:key]) {
		NSArray *ary = self.dicVideoDownloading[key];
		self.dicVideoDownloading[key] = @[[progress copy], [success copy], [faild copy], ary[3]];
		return;
	}

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:highlight.video_url]];
	request.timeoutInterval = kVideoUploadDownloadTimeout;
	AFHTTPRequestOperation *operation = [[RKObjectManager sharedManager].HTTPClient HTTPRequestOperationWithRequest:request
	                                                                                                        success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    [self _skipBackupForURL:[NSURL fileURLWithPath:key]];
	    ZPVoidBlock successCallback = self.dicVideoDownloading[key][1];
	    [self.dicVideoDownloading removeObjectForKey:key];

	    ZPInvokeBlock(successCallback);
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    ZPErrorBlock faildCallback = self.dicVideoDownloading[key][2];
	    [self.dicVideoDownloading removeObjectForKey:key];

	    ZPInvokeBlock(faildCallback, error);
	}];
	[operation setDownloadProgressBlock: ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
	    float currentProgress = totalBytesRead / (float)totalBytesExpectedToRead;

	    ZPFloatBlock progressCallback = self.dicVideoDownloading[key][0];
	    ZPInvokeBlock(progressCallback, currentProgress);
	}];
	operation.outputStream = [NSOutputStream outputStreamToFileAtPath:key append:NO];
	[operation start];

	self.dicVideoDownloading[key] = @[[progress copy], [success copy], [faild copy], operation];
}

- (AVURLAsset *)streamVideoForHighlight:(BSHighlightMO *)highlight progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (!highlight) {
		return nil;
	}
	NSString *path = [self getVideoFullPathForHighlight:highlight];
	if ([self.dicVideoDownloading.allKeys containsObject:path]) {
		NSArray *ary = self.dicVideoDownloading[path];
		AVURLAsset *asset = ary[3];
		self.dicVideoDownloading[path] = @[[progress copy], [success copy], [faild copy], asset];
		return asset;
	}
	
	AVURLAsset *asset = [BSVideoStreamer streamVideoForUrl:[NSURL URLWithString:highlight.video_url] progress:progress success:^(NSData *data) {
		BOOL success = [data writeToFile:path atomically:YES];
		if (!success) {
			ZPLogError(@"write stream video data to file error");
		}
		
		[self _skipBackupForURL:[NSURL fileURLWithPath:path]];
		ZPVoidBlock successCallback = self.dicVideoDownloading[path][1];
		[self.dicVideoDownloading removeObjectForKey:path];
		
		ZPInvokeBlock(successCallback);
	} faild:^(NSError *error) {
		ZPErrorBlock faildCallback = self.dicVideoDownloading[path][2];
		[self.dicVideoDownloading removeObjectForKey:path];
		
		ZPInvokeBlock(faildCallback, error);
	}];
	self.dicVideoDownloading[path] = @[[progress copy], [success copy], [faild copy], asset];
	
	return asset;
}

#pragma mark - post
- (void)postHighlightWithMessage:(NSString *)message coordinate:(CLLocationCoordinate2D)coordinate locationName:(NSString *)locationName sportType:(NSUInteger)sportType localCoverPath:(NSString *)localCoverPath localVideoPath:(NSString *)localVideoPath shootAt:(NSDate *)shootAt shareTypes:(NSString *)shareTypes event:(BSEventMO *)event team:(BSTeamMO *)team {
	if (message.length > 0 && localCoverPath && localVideoPath) {
		BSHighlightMO *highlight = [BSHighlightMO createEntity];
		highlight.user = _currentUser;
		highlight.message = message;
		if (CLLocationCoordinate2DIsValid(coordinate)) {
			highlight.latitudeValue = coordinate.latitude;
			highlight.longitudeValue = coordinate.longitude;
		} else {
			highlight.latitudeValue = highlight.longitudeValue = kInvalidCoordinate;
		}
		highlight.location_name = locationName;
		highlight.sport_typeValue = sportType;
		highlight.local_cover_path = localCoverPath;
		highlight.local_video_path = localVideoPath;
		highlight.shoot_at = shootAt;
		highlight.local_share_types = shareTypes;
		highlight.event = event;
		highlight.team = team;
		highlight.local_identifierValue = [[NSDate date] timeIntervalSince1970];
		highlight.local_is_wait_for_postValue = YES;
		[self save];

		[self postLocalHighlight:highlight progress:^(float value) {
			
		} success:^{
			
		} faild:^(NSError *error) {
			
		}];
	}
}

- (void)postLocalHighlight:(BSHighlightMO *)highlightLocal progress:(ZPFloatBlock)progress success:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (!highlightLocal) {
		return;
	}
	NSNumber *key = highlightLocal.local_identifier;
	if ([self.dicHighlightUploading.allKeys containsObject:key]) {
		self.dicHighlightUploading[key] = @[[progress copy], [success copy], [faild copy]];
		return;
	}
	
	self.dicHighlightUploading[key] = @[[progress copy], [success copy], [faild copy]];
	
//	__weak typeof(self) weakSelf = self;
	
	// step 1
	NSString *localVideoOriginalPath = highlightLocal.local_video_path;
	BSHighlightPostUploadVideoHttpRequest *requestVideo = [BSHighlightPostUploadVideoHttpRequest requestWithVideoFullPath:localVideoOriginalPath];
	requestVideo.clientId = highlightLocal.local_identifierValue;
	requestVideo.timeoutInterval = kVideoUploadDownloadTimeout;
	[requestVideo postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		// step 2
		BSHighlightPostHttpRequest *requestMeta = [BSHighlightPostHttpRequest request];
		requestMeta.message = highlightLocal.message;
		requestMeta.sportType = highlightLocal.sport_typeValue;
		requestMeta.eventId = highlightLocal.event.identifierValue;
		requestMeta.teamId = highlightLocal.team.identifierValue;
		requestMeta.latitude = highlightLocal.latitudeValue;
		requestMeta.longitude = highlightLocal.longitudeValue;
		requestMeta.locationName = highlightLocal.location_name;
		requestMeta.clientId = highlightLocal.local_identifierValue;
		requestMeta.shoot_at = highlightLocal.shoot_at;
		requestMeta.shareTypes = highlightLocal.local_share_types;
		[requestMeta postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			// rename local video
			BSHighlightPostDataModel *dataModel = result.dataModel;
			NSString *serverFileName = [dataModel.highlight.video_url lastPathComponent];
			NSString *localVideoNewPath = [[[BSDataManager sharedInstance] getVideoFullPath] stringByAppendingPathComponent:serverFileName];
			[[NSFileManager defaultManager] moveItemAtPath:localVideoOriginalPath toPath:localVideoNewPath error:NULL];
			
			highlightLocal.identifierValue = dataModel.highlight.identifierValue; // update local id
			highlightLocal.video_url = dataModel.highlight.video_url;
			highlightLocal.local_video_path = localVideoNewPath;
			[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightDidPostedNotification object:dataModel.highlight];
			
			ZPVoidBlock successCallback = self.dicHighlightUploading[key][1];
			[self.dicHighlightUploading removeObjectForKey:key];
			
			ZPInvokeBlock(successCallback);
		} failedBlock:^(BSHttpResponseDataModel *result) {
			ZPErrorBlock faildCallback = self.dicHighlightUploading[key][2];
			[self.dicHighlightUploading removeObjectForKey:key];
			
			ZPInvokeBlock(faildCallback, result.error);
		}];
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPErrorBlock faildCallback = self.dicHighlightUploading[key][2];
		[self.dicHighlightUploading removeObjectForKey:key];
		
		ZPInvokeBlock(faildCallback, result.error);
	}];
	[requestVideo.requestOperation.HTTPRequestOperation setUploadProgressBlock: ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		float currentProgress = (float)totalBytesWritten / totalBytesExpectedToWrite * 0.98;// Step 1 is 0.98 max
		
		ZPFloatBlock progressCallback = self.dicHighlightUploading[key][0];
		ZPInvokeBlock(progressCallback, currentProgress);
	}];
}

- (BOOL)isUploadingForHighlight:(BSHighlightMO *)highlight {
	if (!highlight) {
		return NO;
	}
	else {
		return [self.dicHighlightUploading.allKeys containsObject:highlight.local_identifier];
	}
}

#pragma mark - user created location
- (NSUInteger)addLocationWithName:(NSString *)name {
	if ([name isKindOfClass:[NSString class]]) {
		[_recentCreatedLocations addObject:name];
		return [_recentCreatedLocations indexOfObject:name];
	}
	else
		return NSUIntegerMax;
}

- (void)removeLocationWithName:(NSString *)name {
	[_recentCreatedLocations removeObject:name];
}

@end
