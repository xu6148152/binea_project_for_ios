//
//  ZPBaseDataModel.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"
#import "ZPFoundation.h"

static NSString *const OverwriteRequiredMessage = @"overwrite is required for sub class";

@implementation ZPBaseDataModel

+ (instancetype)modelWithError:(NSError *)error {
	ZPBaseDataModel *model = [[[self class] alloc] init];
	model.error = error;
	return model;
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:[[self responseMappingDictionary] reversedKeyValueDictionary]];
	
	return mapping;
}

+ (NSDictionary *)responseMappingDictionary {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
	
	[mapping addAttributeMappingsFromDictionary:[self responseMappingDictionary]];
	
	return mapping;
}

- (NSInteger)responseStatus {
	NSAssert(NO, OverwriteRequiredMessage);
	return 0;
}

- (void)randomPropertiesForTest {
}

+ (instancetype)randomInstanceForTest {
	return nil;
}

- (NSString *)description {
	return [self allPropertiesDescription];
}

@end
