//
//  BSMeUpdateProfileHttpRequest.h
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSUserBaseHttpRequest.h"

@interface BSMeUpdateProfileHttpRequest : BSUserBaseHttpRequest

@property (nonatomic, assign) int privacy_allow_comments;
@property (nonatomic, assign) BOOL privacy_public_profile;
@property (nonatomic) NSString *sports;
@property (nonatomic, strong) NSString *name_human_readable;

+ (instancetype)requestWithAvatarImage:(UIImage *)avatarImage;

@end
