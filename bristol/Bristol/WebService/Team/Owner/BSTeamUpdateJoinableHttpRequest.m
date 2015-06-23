//
//  BSTeamUpdateJoinableHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 3/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamUpdateJoinableHttpRequest.h"
#import "BSTeamMO.h"

@implementation BSTeamUpdateJoinableHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/update";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{
												  @"teamId" : @"team_id",
												  @"joinable" : @"joinable"
												  }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"team";
}

+ (RKMapping *)responseMapping {
	return [BSTeamMO responseMapping];
}

@end
