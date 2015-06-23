//
//  BSTeamBaseHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSTeamBaseHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType teamId;

+ (instancetype)requestWithTeamId:(DataModelIdType)teamId;

@end
