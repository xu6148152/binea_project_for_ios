//
//  BSRKDateTransformer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "RKValueTransformers.h"

@interface BSRKDateTransformer : NSObject

+ (RKBlockValueTransformer *)timeIntervalInMilliSecondSince1970ToDateValueTransformer;

@end
