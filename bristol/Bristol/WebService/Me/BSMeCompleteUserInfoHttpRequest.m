//
//  BSMeCompleteUserInfoHttpRequest.m
//  Bristol
//
//  Created by Bo on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeCompleteUserInfoHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSMeCompleteUserInfoHttpRequest

+ (NSString *)requestPath {
    return @"me/complete_user_info";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"user_id" : @"user_id",
                                                  @"name_id" : @"username",
                                                  @"name_human_readable" : @"screen_name",
                                                  @"email" : @"email",
                                                  }];
    
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSCompleteUserInfoModel responseMapping];
}


@end
