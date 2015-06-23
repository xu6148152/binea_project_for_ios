//
//  BSEventsDataModel.m
//  Bristol
//
//  Created by Bo on 1/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventsDataModel.h"
#import "BSEventMO.h"

@implementation BSEventsDataModel

+ (NSString *)fromKeyPath {
    return @"events";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"events" withMapping:[BSEventMO responseMapping]]];
    
    return mapping;
}

@end


@implementation BSEventsUserKeyDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{}];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"events" withMapping:[BSEventMO responseMappingWithUserEvents]]];
    
    return mapping;
}

@end
