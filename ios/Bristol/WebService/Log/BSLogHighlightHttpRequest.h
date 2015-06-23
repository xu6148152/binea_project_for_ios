//
//  BSLogHighlightHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSLogHighlightDataModel.h"

@interface BSLogHighlightHttpRequest : BSCustomHttpRequest

+ (instancetype)requestWithLogHighlightDataModels:(NSArray *)models;

@end
