//
//  BSMapAnnotation.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BSMapAnnotation : NSObject <MKAnnotation>

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
