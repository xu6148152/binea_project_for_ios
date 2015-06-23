//
//  BSExploreSearchTeamsHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchTeamsHttpRequest.h"
#import "BSTeamsDataModel.h"

@implementation BSExploreSearchTeamsHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"explore/search_teams";
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSTeamsDataModel responseMapping];
}
@end
