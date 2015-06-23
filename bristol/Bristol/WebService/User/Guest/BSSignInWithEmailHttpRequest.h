//
//  BSSignInWithEmailHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSSignInWithEmailHttpRequest : BSCustomHttpRequest

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

+ (instancetype)requestWithEmail:(NSString *)email password:(NSString *)password;

@end
