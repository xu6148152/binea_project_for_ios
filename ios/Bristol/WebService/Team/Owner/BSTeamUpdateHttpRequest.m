//
//  BSTeamUpdateHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamUpdateHttpRequest.h"
#import "BSTeamMO.h"

@implementation BSTeamUpdateHttpRequest

- (void) setAvatarImage:(UIImage *)avatarImage {
	if (avatarImage) {
		ZPMultipartItem *multipartItem = ZPMultipartItem.alloc.init;
		multipartItem.fileName = @"avatar.png";
		multipartItem.parameterName = @"avatar";
		multipartItem.MIMEType = @"image/png";
		multipartItem.data = UIImagePNGRepresentation(avatarImage);
		self.multipartItem = multipartItem;
	}
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/update";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id",
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
@end
