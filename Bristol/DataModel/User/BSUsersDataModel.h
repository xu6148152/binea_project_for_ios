//
//  BSUsersDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"
#import "BSHighlightsDataModel.h"
#import "BSUserMO.h"

@interface BSUsersDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *users;

+ (NSString *)fromKeyPath;

@end


@interface BSMembersDataModel : BSUsersDataModel

@end


@interface BSFollowersDataModel : BSUsersDataModel

@end

@interface BSRecentFollowersDataModel : BSUsersDataModel

@end

@interface BSSignUpDataModel : BSUsersDataModel

@property (nonatomic, strong) BSUserMO *user;
@property (nonatomic, strong) NSArray *followed_users;

@end

@interface BSSetUserNameDataModel : BSUsersDataModel

@property (nonatomic, strong) NSArray *followed_users;

@end

@interface BSCompleteUserInfoModel : BSUsersDataModel

@property (nonatomic, strong) NSArray *followed_users;

@end

@interface BSCheckUserEmailModel : BSUsersDataModel

@property (nonatomic, assign) BOOL user_exists;
@property (nonatomic, assign) BOOL bristol_logged_in;
@property (nonatomic, assign) BOOL zepp_facebook_user;

@end

@interface BSUsersToFollowModel : BSUsersDataModel

@end
