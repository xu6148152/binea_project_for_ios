//
//  BSMeCompleteUserInfoHttpRequest.h
//  Bristol
//
//  Created by Bo on 4/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserBaseHttpRequest.h"

@interface BSMeCompleteUserInfoHttpRequest : BSUserBaseHttpRequest

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name_id;
@property (nonatomic, strong) NSString *name_human_readable;

@end
