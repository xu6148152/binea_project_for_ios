//
//  BSTeamCreateHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamCreateHttpRequest.h"
#import "BSTeamMO.h"
#import "BSDataManager.h"

@implementation BSTeamCreateHttpRequest

- (void) setAvatarImage:(UIImage *)avatarImage {
	if (avatarImage) {
		ZPMultipartItem *multipartItem = ZPMultipartItem.alloc.init;
		multipartItem.fileName = @"avatar.png";
		multipartItem.parameterName = @"avatar";
		multipartItem.MIMEType = @"image/png";
		multipartItem.data = UIImagePNGRepresentation(avatarImage);
		self.multipartItem = multipartItem;
	} else {
		self.multipartItem = nil;
	}
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/create";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name",
												   @"location" : @"location",
												   @"sports" : @"sports",
												   @"longitude" : @"longitude",
												   @"latitude" : @"latitude" }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"team";
}

+ (RKMapping *)responseMapping {
	return [BSTeamMO responseMappingWithRecentHighlights];
}

- (void) onRequestSucceed:(BSHttpResponseDataModel *)result {
	BSTeamMO *createdTeam = (BSTeamMO *)result.dataModel;
	if (createdTeam) {
		createdTeam.is_managerValue = YES;
		createdTeam.is_memberValue = YES;
		createdTeam.is_followingValue = NO;
		[[BSDataManager sharedInstance].currentUser addJoined_teamsObject:createdTeam];
		[createdTeam addMembersObject:[BSDataManager sharedInstance].currentUser];
	}
}

@end
