//
//  BSFeedSeeAllCommentsTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@interface BSFeedSeeAllCommentsTableViewCell : BSBaseTableViewCell

@property (nonatomic, assign, readonly) BOOL isTapInMultiplyBlendViewArea;

- (void)configWithCommentsCount:(NSUInteger)count;

@end
