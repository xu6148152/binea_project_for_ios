//
//  BSOAuthSignInBaseHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSOAuthSignInBaseHttpRequest : BSCustomHttpRequest
{
	@protected
	NSInteger _timezone;
	NSString *_locale;
}

@property (nonatomic, strong) NSString *accessToken;

@end
