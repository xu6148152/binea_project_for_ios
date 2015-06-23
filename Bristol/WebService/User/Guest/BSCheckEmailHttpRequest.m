//
//  BSCheckEmailHttpRequest.m
//  Bristol
//
//  Created by Bo on 3/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCheckEmailHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSCheckEmailHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"account/check_email";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"email" : @"email" }];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSCheckUserEmailModel responseMapping];
}

@end
