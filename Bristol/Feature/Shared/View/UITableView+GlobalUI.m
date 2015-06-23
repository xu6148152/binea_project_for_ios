//
//  UITableView+GlobalUI.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "UITableView+GlobalUI.h"


@implementation UITableView (GlobalUI)

- (void)setGlobalUI {
	self.clearEmptyFooterSeperator = kClearEmptyTableViewFooterSeperator;
	self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
