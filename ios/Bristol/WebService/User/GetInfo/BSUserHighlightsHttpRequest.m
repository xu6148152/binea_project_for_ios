//
//  BSUserHighlightsHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"

@implementation BSUserHighlightsHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		self.countInOnePage = kDataCountInOnePage;
	}
	return self;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"user/highlights";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
	[mapping addAttributeMappingsFromDictionary:@{ @"user_id" : @"user_id",
												   @"startIndex" : @"start",
												   @"countInOnePage" : @"count", }];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSHighlightsUserKeyDataModel responseMapping];
}

@end
