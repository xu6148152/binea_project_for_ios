//
//  BSHighlightShareUrlDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightShareUrlDataModel.h"

@implementation BSHighlightShareUrlDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{
												  @"url" : @"url",
												  }];
	
	return mapping;
}

@end
