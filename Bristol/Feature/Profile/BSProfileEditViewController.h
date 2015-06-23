//
//  BSProfileEditViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

typedef NS_ENUM (NSUInteger, BSProfileEditDataType) {
	BSProfileEditDataTypeMeUpdate,
	BSProfileEditDataTypeTeamCreate,
	BSProfileEditDataTypeTeamUpdate,
};

@interface BSProfileEditViewController : BSBaseTableViewController

@property (nonatomic, assign) BSProfileEditDataType dataType;
@property (nonatomic) BSUserMO *user;
@property (nonatomic) BSTeamMO *team;

@end
