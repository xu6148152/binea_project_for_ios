//
//  BSHighlightCommentsDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightCommentsDataModel.h"
#import "BSCommentMO.h"

@implementation BSHighlightCommentsDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comments" toKeyPath:@"comments" withMapping:[BSCommentMO responseMapping]]];
    
    return mapping;
}

+ (RKMapping *)addCommentResponseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comment" toKeyPath:@"comments" withMapping:[BSCommentMO responseMapping]]];
    
    return mapping;
}

@end
