//
//  BSExploreUsersToFollowHttpRequest.m
//  Bristol
//
//  Created by Bo on 4/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreUsersToFollowHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSExploreUsersToFollowHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"explore/users_to_follow";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id" }];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSUsersToFollowModel responseMapping];
}

@end
