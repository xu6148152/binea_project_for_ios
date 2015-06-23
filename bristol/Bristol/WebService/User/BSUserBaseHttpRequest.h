//
//  BSUserBaseHttpRequest.h
//  Bristol
//
//  Created by Bo on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSUserBaseHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType user_id;

+ (instancetype)requestWithUserId:(DataModelIdType)userId;

@end
