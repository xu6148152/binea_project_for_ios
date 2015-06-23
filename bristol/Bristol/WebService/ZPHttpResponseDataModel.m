//
//  ZPHttpResponseDataModel.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/19/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPHttpResponseDataModel.h"
#import "RestKit.h"


@interface ZPHttpResponseDataModel ()
@end

@implementation ZPHttpResponseDataModel
@synthesize error = _error;

+ (instancetype)modelWithStatus:(NSInteger)status message:(NSString *)message error:(NSError *)error {
	ZPHttpResponseDataModel *model = [[ZPHttpResponseDataModel alloc] init];

	model.status = status;
	model.message = message;
	model.error = error;

	return model;
}

+ (instancetype)modelWithStatus:(NSInteger)status message:(NSString *)message {
	return [ZPHttpResponseDataModel modelWithStatus:status message:message error:nil];
}

- (id)init {
	self = [super init];
	if (self) {
		_status = 0;
	}
	return self;
}

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];

	[mapping addAttributeMappingsFromDictionary:@{ @"status":@"status",
	                                               @"message":@"message",
	                                               @"messageDebug":@"messageDebug" }];
	return mapping;
}

- (NSString *)message {
	if (_message) {
		return _message;
	} else {
		return self.messageDebug;
	}
}

- (NSInteger)responseStatus {
	return _status;
}

- (NSError *)error {
	if (_error) {
		return _error;
	} else {
		return [NSError errorWithDomain:@"com.zepp.RESTful" code:self.status userInfo:@{NSLocalizedDescriptionKey : self.message ?: @""}];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"\n status:%i \n message:%@ \n messageDebug:%@ \n error:%@ \n dataModel:%@ \n", (int)self.status, self.message, self.messageDebug, self.error, self.dataModel];
}

@end
