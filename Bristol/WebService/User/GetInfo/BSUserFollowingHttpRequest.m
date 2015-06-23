//
//  BSUserFollowingDataModel.m
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserFollowingHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSUserFollowingHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"user/following";
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
    return [BSUsersDataModel responseMapping];
}
@end
