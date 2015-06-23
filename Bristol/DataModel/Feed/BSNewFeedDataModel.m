//
//  BSNewFeedDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSNewFeedDataModel.h"

@implementation BSNewFeedDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"new" : @"newFeedsCount", }];
	
	return mapping;
}

@end
