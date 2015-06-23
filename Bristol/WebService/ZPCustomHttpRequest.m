//
//  ZPCustomHttpRequest.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 1/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPCustomHttpRequest.h"

@interface ZPCustomHttpRequest()

@property (nonatomic, strong) NSString *deviceIdentifier;

@end

@implementation ZPCustomHttpRequest

- (id)init {
    self = [super init];
	if (self) {
		self.statusSuccessValue = 200;
        _deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return self;
}

- (RKRequestDescriptor *)requestDescriptor {
	RKRequestDescriptor *requestDescriptor = [super requestDescriptor];
	[((RKObjectMapping *)requestDescriptor.mapping)addAttributeMappingsFromDictionary : @{
	     @"authToken" : @"auth_token",
	     @"deviceIdentifier" : @"device_identifier"
	 }];

	return requestDescriptor;
}

+ (RKMapping *)responseMapping {
	return nil;
}

+ (RKMapping *)responseMappingCustomized {
	RKObjectMapping *mapping = (RKObjectMapping *)[ZPHttpResponseDataModel responseMapping];
	RKMapping *dataMapping = [self.class responseMapping];
	if (dataMapping) {
		RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:[self.class responsePath]
																								 toKeyPath:@"dataModel"
																							   withMapping:dataMapping];
		[mapping addPropertyMapping:relationshipMapping];
	}
	return mapping;
}

- (void)postRequestWithSucceedBlock:(ZPCustomHttpRequestCompletedBlock)succeedBlock failedBlock:(ZPCustomHttpRequestCompletedBlock)failedBlock {
	[super postRequestCustomizedWithSucceedBlock:succeedBlock failedBlock:failedBlock];
}

@end
