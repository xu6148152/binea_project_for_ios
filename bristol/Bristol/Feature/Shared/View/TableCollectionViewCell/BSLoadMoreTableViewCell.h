//
//  BSLoadMoreTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "BSLoadMoreType.h"

@interface BSLoadMoreTableViewCell : BSBaseTableViewCell

@property (nonatomic, assign) BSLoadMoreType loadMoreType;

@property (weak, nonatomic) IBOutlet UILabel *lblFaild;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;

@end
