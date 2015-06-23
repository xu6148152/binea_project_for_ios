//
//  BSEventBaseHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventBaseHttpRequest.h"

@implementation BSEventBaseHttpRequest

+ (instancetype)requestWithEventId:(DataModelIdType)eventId {
	BSEventBaseHttpRequest *request = [[[self class] alloc] init];
	request.eventId = eventId;
	return request;
}

@end
