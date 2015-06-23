//
//  BSExploreHighlightsHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"

@implementation BSExploreHighlightsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"explore/highlights";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSHighlightsDataModel responseMapping];
}

@end
