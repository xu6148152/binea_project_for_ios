//
//  BSHighlightsDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightsDataModel.h"
#import "BSHighlightMO.h"

@implementation BSHighlightsDataModel

+ (NSString *)fromKeyPath {
    return @"highlights";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"highlights" withMapping:[BSHighlightMO responseMapping]]];
    
    return mapping;
}

@end


@implementation BSHighlightsUserKeyDataModel

+ (NSString *)fromKeyPath {
    return @"highlights";
}

@end


@implementation BSRecentHighlightDataModel

+ (NSString *)fromKeyPath {
    return @"recent_highlights";
}

@end
