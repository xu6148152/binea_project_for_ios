//
//  BSTopTenHttpRequest.m
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenHttpRequest.h"
#import "BSHighlightMO.h"
#import "BSHighlightsDataModel.h"
#import "BSTopDataModel.h"

@implementation BSTopTenHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return nil;
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"week" : @"week" }];
    
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSTopDataModel responseMapping];
}

@end
