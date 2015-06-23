//
//  BSMeChangePasswordHttpRequest.m
//  Bristol
//
//  Created by Bo on 2/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMeChangePasswordHttpRequest.h"

@implementation BSMeChangePasswordHttpRequest

+ (NSString *)requestPath {
    return @"me/change_password";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id" }];
    [mapping addAttributeMappingsFromDictionary:@{ @"oldPassword" : @"old_password" }];
    [mapping addAttributeMappingsFromDictionary:@{ @"currentPassword" : @"new_password" }];
    return mapping;
}

+ (NSString *)responsePath {
    return @"user";
}

+ (RKMapping *)responseMapping {
    return nil;
}

@end
