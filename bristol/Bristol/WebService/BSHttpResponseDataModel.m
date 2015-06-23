//
//  BSHttpResponseDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHttpResponseDataModel.h"

@implementation BSHttpResponseDataModel
{
	NSError *_error;
}
@synthesize error = _error;

- (id)init {
	self = [super init];
	if (self) {
		_code = -1;
	}
	return self;
}

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"code":@"code",
												   @"error_case":@"apiCase",
												   @"error_message":@"message" }];
	return mapping;
}

- (NSInteger)responseStatus {
	return _code;
}

- (NSError *)error {
	if (_error) {
		return _error;
	} else {
		return [NSError errorWithDomain:@"com.zepp.RESTful" code:self.code userInfo:@{NSLocalizedDescriptionKey : self.message ?: @""}];
	}
}

@end
