//
//  BSEventUpdateHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEventBaseHttpRequest.h"

@class BSEventMO;

@interface BSEventUpdateHttpRequest : BSEventBaseHttpRequest

@property (nonatomic, strong) BSEventMO *event;

@end
