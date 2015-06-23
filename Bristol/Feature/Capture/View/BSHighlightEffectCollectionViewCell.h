//
//  BSHighlightEffectCollectionViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSHighlightBaseEffectModel;

@interface BSHighlightEffectCollectionViewCell : UICollectionViewCell

- (void)configWithHighlightEffectModel:(BSHighlightBaseEffectModel *)model;

@end
