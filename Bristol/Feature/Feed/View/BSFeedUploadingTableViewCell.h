//
//  BSFeedUploadingTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/18/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@class BSFeedUploadingTableViewCell;
@protocol BSFeedUploadingTableViewCellDelegate <NSObject>
@optional
- (void)feedUploadingCell:(BSFeedUploadingTableViewCell *)cell didTapCloseButton:(UIButton *)button;

@end

@class BSHighlightMO;
@interface BSFeedUploadingTableViewCell : BSBaseTableViewCell

@property (strong, nonatomic, readonly) BSHighlightMO *highlight;
@property (weak, nonatomic) id <BSFeedUploadingTableViewCellDelegate> delegate;

- (void)configWithHighlight:(BSHighlightMO *)highlight;

@end
