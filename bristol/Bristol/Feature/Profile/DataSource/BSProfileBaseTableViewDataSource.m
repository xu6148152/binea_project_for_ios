//
//  BSBaseTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileBaseTableViewDataSource.h"

@interface BSProfileBaseTableViewDataSource ()

@end

@implementation BSProfileBaseTableViewDataSource

+ (instancetype)dataSourceWithUser:(BSUserMO *)user {
	return [[[self class] alloc] initWithUserMO:user];
}

- (id)initWithUserMO:(BSUserMO *)user {
	NSParameterAssert([user isKindOfClass:[BSUserMO class]]);
	self = [super init];
	if (self) {
		_user = user;
	}
	return self;
}

@end
