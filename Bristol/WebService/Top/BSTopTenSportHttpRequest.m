//
//  BSTopTenSportHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenSportHttpRequest.h"
#import "BSTopDataModel.h"
#import "BSHighlightMO.h"

@implementation BSTopTenSportHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"top/of_sport";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"week" : @"week",
                                                   @"sport_type" : @"sport_type"
                                                   }];
    return mapping;
}

@end
