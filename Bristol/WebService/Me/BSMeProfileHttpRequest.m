//
//  BSMeProfileHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeProfileHttpRequest.h"
#import "BSUserMO.h"

@implementation BSMeProfileHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"me/profile";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id" }];
    return mapping;
}

+ (NSString *)responsePath {
    return @"user";
}

+ (RKMapping *)responseMapping {
    return [BSUserMO responseMappingWithUserProfile];
}

@end
