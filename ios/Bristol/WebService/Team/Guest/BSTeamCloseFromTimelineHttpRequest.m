//
//  BSTeamCloseFromTimelineHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/18/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamCloseFromTimelineHttpRequest.h"

@implementation BSTeamCloseFromTimelineHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/close_from_timeline";
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
