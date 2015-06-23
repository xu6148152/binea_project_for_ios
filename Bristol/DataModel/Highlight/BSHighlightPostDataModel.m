//
//  BSHighlightPostDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightPostDataModel.h"

@implementation BSHighlightPostDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{@"share_url" : @"share_url"}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlight" toKeyPath:@"highlight" withMapping:[BSHighlightMO responseMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"highlight_video_buffer" toKeyPath:@"highlightVideoBuffer" withMapping:[BSHighlightVideoBufferDataModel responseMapping]]];
    
    return mapping;
}

@end
