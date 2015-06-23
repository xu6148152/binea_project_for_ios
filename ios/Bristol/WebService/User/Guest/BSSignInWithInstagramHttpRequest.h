//
//  BSSignInWithInstagramHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSSignInWithInstagramHttpRequest : BSCustomHttpRequest

@property (nonatomic, strong) NSString *code;

@end
