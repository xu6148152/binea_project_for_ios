//
//  BSFeedDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@class BSHighlightMO;

@interface BSFeedDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *highlights;
@property (nonatomic, strong) NSArray *recomendEvents;
@property (nonatomic, strong) NSArray *recomendTeams;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, assign) DataModelIdType last_highlight;

@end
