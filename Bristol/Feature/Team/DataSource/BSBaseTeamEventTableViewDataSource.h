//
//  BSBaseTeamEventTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewDataSource.h"
#import "BSTableViewDataSourceDataModel.h"
#import "BSUserMO.h"

@interface BSBaseTeamEventTableViewDataSource : BSBaseTableViewDataSource
{
	@protected
	BSTableViewDataSourceDataModel *_dataModel;
}

@property (nonatomic, strong, readonly) BSUserMO *user;

+ (instancetype)dataSourceWithUser:(BSUserMO *)user;

- (id)initWithUserMO:(BSUserMO *)user;

@end
