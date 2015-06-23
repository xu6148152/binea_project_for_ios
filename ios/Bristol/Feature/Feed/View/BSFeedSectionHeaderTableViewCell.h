//
//  BSFeedSectionHeaderTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@class BSHighlightMO;
@interface BSFeedSectionHeaderTableViewCell : UITableViewHeaderFooterView

- (void)configWithHighlight:(BSHighlightMO *)highlight;

@end
