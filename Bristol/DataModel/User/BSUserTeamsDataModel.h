//
//  BSUserTeamsDataModel.h
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSUserTeamsDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *followedTeams;
@property (nonatomic, strong) NSArray *joinedTeams;

@end
