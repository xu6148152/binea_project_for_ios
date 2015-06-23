//
//  BSHttpResponseDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSHttpResponseDataModel : ZPBaseDataModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger apiCase;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id dataModel;

@end
