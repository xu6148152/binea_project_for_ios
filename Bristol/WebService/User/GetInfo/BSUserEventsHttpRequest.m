//
//  BSUserEventHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserEventsHttpRequest.h"
#import "BSEventsDataModel.h"

@implementation BSUserEventsHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"user/events";
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
    return [BSEventsUserKeyDataModel responseMapping];
}
@end
