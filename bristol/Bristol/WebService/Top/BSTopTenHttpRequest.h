//
//  BSTopTenHttpRequest.h
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSTopTenHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) NSInteger sport_type;
@property (nonatomic, assign) DataModelIdType event_id;

@end
