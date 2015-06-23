//
//  BSMeUpdateProfileHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeUpdateProfileHttpRequest.h"
#import "BSUserMO.h"

@interface BSMeUpdateProfileHttpRequest()
@property (nonatomic, assign) int privacy_public_profile_int;

@end

@implementation BSMeUpdateProfileHttpRequest

+ (instancetype)requestWithAvatarImage:(UIImage *)avatarImage {
    BSMeUpdateProfileHttpRequest *request = [[BSMeUpdateProfileHttpRequest alloc] init];
	if (avatarImage) {
		ZPMultipartItem *multipartItem = ZPMultipartItem.alloc.init;
		multipartItem.fileName = @"avatar.png";
		multipartItem.parameterName = @"avatar";
		multipartItem.MIMEType = @"image/png";
		multipartItem.data = UIImagePNGRepresentation(avatarImage);
		request.multipartItem = multipartItem;
	}
	
    return request;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.privacy_public_profile = YES;
		self.privacy_allow_comments = 1;
	}
	return self;
}

- (void)setPrivacy_public_profile:(BOOL)privacy_public_profile {
	_privacy_public_profile = privacy_public_profile;
	_privacy_public_profile_int = privacy_public_profile ? 1 : 0;
}

- (void)setPrivacy_allow_comments:(int)privacy_allow_comments {
	if (privacy_allow_comments < 1) {
		privacy_allow_comments = 1;
	} else if (privacy_allow_comments > 2) {
		privacy_allow_comments = 2;
	}
	_privacy_allow_comments = privacy_allow_comments;
}

+ (NSString *)requestPath {
    return @"me/update_profile";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id",
                                                   @"name_human_readable" : @"screen_name",
                                                   @"privacy_allow_comments" : @"privacy_allow_comments",
                                                   @"privacy_public_profile_int" : @"privacy_public_profile",
												   @"sports" : @"sports",
                                                   }];
    return mapping;
}

+ (NSString *)responsePath {
    return @"user";
}

+ (RKMapping *)responseMapping {
	return [BSUserMO responseMappingWithUserProfile];
}
@end
