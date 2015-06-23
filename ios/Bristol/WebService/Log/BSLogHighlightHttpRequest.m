//
//  BSLogHighlightHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLogHighlightHttpRequest.h"

@interface BSLogHighlightHttpRequest()

@property(nonatomic, strong) NSArray *aryModels;

@end

@implementation BSLogHighlightHttpRequest

+ (instancetype)requestWithLogHighlightDataModels:(NSArray *)models {
    BSLogHighlightHttpRequest *request = [BSLogHighlightHttpRequest request];
    request.aryModels = models;

    return request;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"log/highlights_played";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"aryModels" toKeyPath:@"times" withMapping:[BSLogHighlightDataModel requestMapping]]];
    
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return nil;
}

@end
