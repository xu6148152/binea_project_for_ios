//
//  BSExploreSearchHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreSearchHttpRequest.h"

@implementation BSExploreSearchHttpRequest

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"keyword" : @"keyword" }];
	return mapping;
}

@end
