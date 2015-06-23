//
//  BSEventBaseHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSEventBaseHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType eventId;

+ (instancetype)requestWithEventId:(DataModelIdType)eventId;

@end
