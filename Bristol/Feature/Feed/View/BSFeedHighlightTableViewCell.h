//
//  BSFeedHighlightTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAttributedTableViewCell.h"
#import "TTTAttributedLabel.h"

@class BSAvatarButton;
@class BSHighlightMO;


@interface BSFeedHighlightTableViewCell : BSAttributedTableViewCell

- (void)configWithHighlight:(BSHighlightMO *)highlight;

- (void)checkIfCanPlayVideo;
- (BOOL)playVideo;
- (void)pauseVideo;

@end
