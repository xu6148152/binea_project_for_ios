//
//  BSMeSetUsernameHttpRequest.m
//  Bristol
//
//  Created by Bo on 3/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeSetUsernameHttpRequest.h"
#import "BSUserMO.h"
#import "BSUsersDataModel.h"

@implementation BSMeSetUsernameHttpRequest

+ (NSString *)requestPath {
    return @"me/set_username";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"user_id" : @"user_id",
                                                  @"name_id" : @"username",
                                                  @"name_human_readable" : @"screen_name"
                                                  }];
    
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSSetUserNameDataModel responseMapping];
}

@end
