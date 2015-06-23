//
//  UITableView+Addition.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/4/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "UITableView+Addition.h"

@implementation UITableView (Addition)

- (void)setClearEmptyFooterSeperator:(BOOL)clearEmptyFooterSeperator {
    if (clearEmptyFooterSeperator)
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    else
        self.tableFooterView = nil;
}

- (BOOL)clearEmptyFooterSeperator {
    return self.tableFooterView != nil;
}

@end
