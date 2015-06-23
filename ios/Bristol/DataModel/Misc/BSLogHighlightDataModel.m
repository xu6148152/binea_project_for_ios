//
//  BSLogHighlightDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLogHighlightDataModel.h"

@implementation BSLogHighlightDataModel

+ (instancetype)dataModelWithHighlightId:(DataModelIdType)highlightId playedTimes:(NSUInteger)playedTimes{
    BSLogHighlightDataModel *model = BSLogHighlightDataModel.alloc.init;
    model.highlightId = highlightId;
    model.playedTimes = playedTimes;
    return model;
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
//    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"highlightId"];
//    [mapping addAttributeMappingsFromDictionary:@{
//                                                  @"(highlightId).playedTimes": @"playedTimes",
//                                                  }];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"highlightId": @"highlight_id",
                                                  @"playedTimes": @"played_times",
                                                  }];
     
    return mapping;
}

@end

