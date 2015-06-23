//
//  BSBaseTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseDataSource.h"

@protocol BSBaseTableViewScrollDelegate <NSObject>
- (void)tableViewDidScroll:(UITableView *)tableView;
@end

@interface BSBaseTableViewDataSource : BSBaseDataSource <UITableViewDataSource, UITableViewDelegate>
{
	@protected
	__weak UITableView *_tableView;
}

@property (nonatomic, weak) id<BSBaseTableViewScrollDelegate> scrollDelegate;

@end
