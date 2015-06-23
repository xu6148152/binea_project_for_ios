//
//  BSTopRankDataModel.h
//  Bristol
//
//  Created by Bo on 4/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"
#import "BSHighlightMO.h"

@interface BSTopRankDataModel : ZPBaseDataModel

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, strong) BSHighlightMO *highlight;

@end
