//
//  BSTopRankDataModel.m
//  Bristol
//
//  Created by Bo on 4/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopRankDataModel.h"
#import "BSHighlightMO.h"

@implementation BSTopRankDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{@"rank" : @"rank"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlight" toKeyPath:@"highlight" withMapping:[BSHighlightMO responseMapping]]];
    
    return mapping;
}

@end
