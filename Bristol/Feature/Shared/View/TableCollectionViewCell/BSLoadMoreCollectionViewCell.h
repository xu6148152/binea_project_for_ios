//
//  BSLoadMoreCollectionViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseCollectionViewCell.h"
#import "BSLoadMoreType.h"

@interface BSLoadMoreCollectionViewCell : BSBaseCollectionViewCell

@property (nonatomic, assign) BSLoadMoreType loadMoreType;

@property (weak, nonatomic) IBOutlet UILabel *lblFaild;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;

@end
