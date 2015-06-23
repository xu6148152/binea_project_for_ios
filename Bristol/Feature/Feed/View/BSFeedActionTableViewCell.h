//
//  BSFeedActionTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@class BSHighlightMO;
@class BSFeedActionTableViewCell;


@interface BSFeedActionTableViewCell : BSBaseTableViewCell

@property (strong, nonatomic, readonly) BSHighlightMO *highlight;

- (void)configWithHighlight:(BSHighlightMO *)highlight;

@end
