//
//  BSExploreTeamsHttps.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreTeamsHttpRequest.h"
#import "BSTeamsDataModel.h"

@implementation BSExploreTeamsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"explore/teams";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSTeamsDataModel responseMapping];
}

@end
