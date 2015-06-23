//
//  BSQueryNearbyPlacesHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import <CoreLocation/CoreLocation.h>

@interface BSQueryNearbyPlacesHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

+ (instancetype)requestWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
