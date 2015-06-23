//
//  BSSignInWithTwitterHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSOAuthSignInBaseHttpRequest.h"

@interface BSSignInWithTwitterHttpRequest : BSOAuthSignInBaseHttpRequest

@property (nonatomic, strong) NSString *accessSecret;

@end
