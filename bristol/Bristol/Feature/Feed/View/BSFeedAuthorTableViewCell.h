//
//  BSFeedAuthorTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/17/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "BSAttributedTableViewCell.h"

@class BSHighlightMO;

@class BSFeedAuthorTableViewCell;
@protocol BSFeedAuthorTableViewCellDelegate <NSObject>

@optional
- (void)feedAuthorTableViewCell:(BSFeedAuthorTableViewCell *)feedActionCell willTapShareButton:(UIButton *)button;
- (void)feedAuthorTableViewCell:(BSFeedAuthorTableViewCell *)feedActionCell didTapActionButton:(UIButton *)button;

@end

@interface BSFeedAuthorTableViewCell : BSAttributedTableViewCell

@property (strong, nonatomic, readonly) BSHighlightMO *highlight;
@property (weak, nonatomic) id <BSFeedAuthorTableViewCellDelegate> delegate;

- (void)configWithHighlight:(BSHighlightMO *)highlight;

@end
