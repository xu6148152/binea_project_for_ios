//
//  BSLogHighlightDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSLogHighlightDataModel : ZPBaseDataModel

@property (nonatomic, assign) DataModelIdType highlightId;
@property (nonatomic, assign) NSUInteger playedTimes;

+ (instancetype)dataModelWithHighlightId:(DataModelIdType)highlightId playedTimes:(NSUInteger)playedTimes;

@end
