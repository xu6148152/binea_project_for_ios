//
//  BSMeSetUsernameHttpRequest.h
//  Bristol
//
//  Created by Bo on 3/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserBaseHttpRequest.h"

@interface BSMeSetUsernameHttpRequest : BSUserBaseHttpRequest

@property (nonatomic, strong) NSString *name_id;
@property (nonatomic, strong) NSString *name_human_readable;

@end
