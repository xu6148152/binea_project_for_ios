//
//  BSEventsDataModel.h
//  Bristol
//
//  Created by Bo on 1/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSEventsDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *events;

+ (NSString *)fromKeyPath;

@end

@interface BSEventsUserKeyDataModel : BSEventsDataModel

@end
