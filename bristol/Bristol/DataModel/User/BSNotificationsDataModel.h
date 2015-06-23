//
//  BSNotificationsDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@class BSNotificationMO;
@interface BSNotificationsDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *notifications; // array of BSNotificationMO entities
@property (nonatomic, strong) NSDate *last_read_date;

@end
