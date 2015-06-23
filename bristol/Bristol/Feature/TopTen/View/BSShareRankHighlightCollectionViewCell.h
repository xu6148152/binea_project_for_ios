//
//  BSShareRankHighlightCollectionViewCell.h
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSShareRankHighlightCollectionViewCell;
@protocol BSShareRankHighlightCollectionViewCellDelegate <NSObject>
@optional

- (void)shareRankHighlightCollectionViewCell:(BSShareRankHighlightCollectionViewCell *)cell didTapShareButton:(UIButton *)didTapShareButton;

@end

@interface BSShareRankHighlightCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) id <BSShareRankHighlightCollectionViewCellDelegate> delegate;

@end
