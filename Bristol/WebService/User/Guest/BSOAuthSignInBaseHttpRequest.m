//
//  BSOAuthSignInBaseHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSOAuthSignInBaseHttpRequest.h"

@implementation BSOAuthSignInBaseHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		_locale = [[NSLocale currentLocale] localeIdentifier];
		_timezone = [[NSTimeZone localTimeZone] secondsFromGMT] / 3600.;
	}
	return self;
}

@end
