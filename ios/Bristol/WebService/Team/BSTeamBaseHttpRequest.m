//
//  BSTeamBaseHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamBaseHttpRequest.h"

@implementation BSTeamBaseHttpRequest

+ (instancetype)requestWithTeamId:(DataModelIdType)teamId {
	BSTeamBaseHttpRequest *request = [[[self class] alloc] init];
	request.teamId = teamId;
	return request;
}

@end
