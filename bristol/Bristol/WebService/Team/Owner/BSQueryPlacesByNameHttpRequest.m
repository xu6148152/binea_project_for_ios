//
//  BSQueryPlacesByNameHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 3/27/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSQueryPlacesByNameHttpRequest.h"

@implementation BSCitiesDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cities" toKeyPath:@"cities" withMapping:[BSHighlightPlaceDataModel responseMapping]]];

	return mapping;
}
@end

@implementation BSQueryPlacesByNameHttpRequest
+ (instancetype)requestWithName:(NSString *)name {
	BSQueryPlacesByNameHttpRequest *request = [[BSQueryPlacesByNameHttpRequest alloc] init];
	request.name = name;
	
	return request;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/query_city_by_name";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	[mapping addAttributeMappingsFromDictionary:@{ @"name" : @"name",}];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSCitiesDataModel responseMapping];
}

@end
