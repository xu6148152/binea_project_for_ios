//
//  BSQueryNearbyPlacesHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSQueryNearbyPlacesHttpRequest.h"
#import "BSHighlightPlaceDataModel.h"

@implementation BSQueryNearbyPlacesHttpRequest

+ (instancetype)requestWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    BSQueryNearbyPlacesHttpRequest *requst = [[BSQueryNearbyPlacesHttpRequest alloc] init];
    requst.latitude = latitude;
    requst.longitude = longitude;
    
    return requst;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/query_nearby_places";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"latitude" : @"latitude",
	     @"longitude" : @"longitude",
	 }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSHighlightPlacesDataModel responseMapping];
}

@end
