//
//  BSTopTenHelpMeTopHttpRequest.m
//  Bristol
//
//  Created by Gary Wong on 5/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenHelpMeTopHttpRequest.h"

@implementation BSTopTenHelpMeTopBaseHttpRequest

+ (NSString *)requestPath {
	return @"top/help_me_top";
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end


@implementation BSTopTenHelpMeTopInFriendHttpRequest

- (NSInteger)list_type {
	return 1;
}

#pragma mark - overwrite -
+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"highlight_id" : @"highlight_id",
                                                   @"current_rank" : @"current_rank",
                                                   @"list_type" : @"list_type",
                                                   }];
    
    return mapping;
}

@end


@implementation BSTopTenHelpMeTopInEventHttpRequest

- (NSInteger)list_type {
	return 3;
}

#pragma mark - overwrite -
+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"event_id" : @"event_id",
												   @"highlight_id" : @"highlight_id",
												   @"current_rank" : @"current_rank",
												   @"list_type" : @"list_type",
												   }];
	
	return mapping;
}

@end


@implementation BSTopTenHelpMeTopInSportHttpRequest

- (NSInteger)list_type {
	return 2;
}

#pragma mark - overwrite -
+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"highlight_id" : @"highlight_id",
												   @"current_rank" : @"current_rank",
												   @"list_type" : @"list_type",
												   @"sport_type" : @"sport_type",
												   }];
	
	return mapping;
}

@end
