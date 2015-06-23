//
//  BSFeedCommentTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAttributedTableViewCell.h"

@class BSAvatarButton;
@class BSCommentMO;
@class BSUserMO;
@class BSHighlightMO;
@class BSFeedCommentTableViewCell;

@protocol BSFeedCommentTableViewCellDelegate <NSObject>

@optional
- (void)feedCommentCell:(BSFeedCommentTableViewCell *)feedCommentCell didSelectCommenter:(BSUserMO *)commenter;
- (void)feedCommentCell:(BSFeedCommentTableViewCell *)feedCommentCell didSelectURL:(NSURL *)url;
- (void)feedCommentCell:(BSFeedCommentTableViewCell *)feedCommentCell didSelectHashtag:(NSString *)hashtag;
- (void)feedCommentCell:(BSFeedCommentTableViewCell *)feedCommentCell didSelectMention:(NSString *)mention;

@end


@interface BSFeedCommentTableViewCell : BSAttributedTableViewCell

@property (nonatomic, assign, readonly) BOOL isTapInMultiplyBlendViewArea;
@property (weak, nonatomic) id <BSFeedCommentTableViewCellDelegate> delegate;

- (void)configWithDataModel:(id)dataModel showCommenter:(BOOL)showCommenter;

@end
