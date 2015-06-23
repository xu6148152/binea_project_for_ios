//
//  BSExploreEventsHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreEventsHttpRequest.h"
#import "BSEventsDataModel.h"

@implementation BSExploreEventsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"explore/events";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSEventsUserKeyDataModel responseMapping];
}

@end
