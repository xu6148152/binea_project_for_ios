//
//  BSHighlightPostHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightPostHttpRequest.h"
#import "BSHighlightPostDataModel.h"
#import "BSUserMO.h"

@interface BSHighlightPostHttpRequest ()

@property (nonatomic, strong) NSNumber *shoot_atNumber; // in milli-seconds

@end

@implementation BSHighlightPostHttpRequest

- (void)setShoot_at:(NSDate *)shoot_at {
	_shoot_at = shoot_at;
	long long milliSeconds = (long long)([shoot_at timeIntervalSince1970] * 1000);
	_shoot_atNumber = @(milliSeconds);
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/post";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"clientId" : @"client_id",
	     @"teamId" : @"team_id",
	     @"eventId" : @"event_id",
	     @"sportType" : @"sport_type",
	     @"latitude" : @"latitude",
	     @"longitude" : @"longitude",
	     @"locationName" : @"location",
		 @"message" : @"message",
		 @"shareTypes" : @"share",
		 @"shoot_atNumber" : @"shoot_at",
	 }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSHighlightPostDataModel responseMapping];
}

@end
