//
//  BSTopTenFollowedEventsHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenFollowedEventsHttpRequest.h"
#import "BSTopDataModel.h"
#import "BSHighlightMO.h"

@implementation BSTopTenFollowedEventsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"top/followed_events";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"week" : @"week",
                                                   @"event_id" : @"event_id"
                                                   }];
    return mapping;
}

@end
