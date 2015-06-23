//
//  BSTopDataModel.m
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopDataModel.h"
#import "BSHighlightMO.h"
#import "BSTopRankDataModel.h"

@implementation BSTopDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{@"total" : @"total"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlights" toKeyPath:@"highlights" withMapping:[BSHighlightMO responseMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"my_ranks" toKeyPath:@"my_ranks" withMapping:[BSTopRankDataModel responseMapping]]];
    
    return mapping;
}

@end
