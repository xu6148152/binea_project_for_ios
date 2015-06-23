//
//  BSTopDataModel.h
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSTopDataModel : ZPBaseDataModel

@property (nonatomic, assign) long long total;
@property (nonatomic, strong) NSArray *highlights;
@property (nonatomic, strong) NSArray *my_ranks;

@end
