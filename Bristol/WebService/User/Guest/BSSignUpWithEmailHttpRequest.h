//
//  BSSignUpWithEmailHttpRequest.h
//  Bristol
//
//  Created by Bo on 3/23/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSSignUpWithEmailHttpRequest : BSCustomHttpRequest

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name_id;
@property (nonatomic, strong) NSString *name_human_readable;

+ (instancetype)requestWithEmail:(NSString *)email password:(NSString *)password;

@end
