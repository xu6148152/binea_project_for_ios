//
//  BSForgetPasswordHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPCustomHttpRequest.h"

@interface BSForgetPasswordHttpRequest : ZPCustomHttpRequest

@property (nonatomic, strong) NSString *email;

@end
