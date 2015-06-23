//
//  BSMapAnnotation.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSMapAnnotation.h"

@implementation BSMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	if(self = [super init])
		self.coordinate = coordinate;
	return self;
}

@end
