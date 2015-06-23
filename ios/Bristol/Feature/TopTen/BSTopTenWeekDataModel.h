//
//  BSTopTenWeekDataModel.h
//  Bristol
//
//  Created by Bo on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSTopDataModel.h"

@interface BSTopTenWeekDataModel : NSObject

@property (nonatomic, strong) NSDate *thisMonday;
@property (nonatomic, strong) NSDate *thisSunday;
@property (nonatomic, strong) NSDate *lastMonday;
@property (nonatomic, assign) BSToptenChannelType channelType;
@property (nonatomic, strong) BSTopDataModel *topModel;
@property (nonatomic, assign) long long identifier;

@end
