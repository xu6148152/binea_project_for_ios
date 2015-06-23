//
//  BSMeChangePasswordHttpRequest.h
//  Bristol
//
//  Created by Bo on 2/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSUserBaseHttpRequest.h"

@interface BSMeChangePasswordHttpRequest : BSUserBaseHttpRequest

@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *currentPassword;

@end
