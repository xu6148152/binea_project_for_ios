//
//  BSExploreCheckFriendsOnFacebookHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreCheckFriendsOnFacebookHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSExploreCheckFriendsOnFacebookHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"explore/check_facebook_friends";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"ids" : @"facebook_ids" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSUsersToFollowModel responseMapping];
}

@end
