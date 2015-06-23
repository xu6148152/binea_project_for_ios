//
//  BSExploreSearchPeopleHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchPeopleHttpRequest.h"
#import "BSUsersDataModel.h"

@implementation BSExploreSearchPeopleHttpRequest
#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"explore/search_people";
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSUsersDataModel responseMapping];
}
@end
