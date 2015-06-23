//
//  BSTeamLeaveHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamLeaveHttpRequest.h"

@implementation BSTeamLeaveHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/leave";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return nil;
}

@end
