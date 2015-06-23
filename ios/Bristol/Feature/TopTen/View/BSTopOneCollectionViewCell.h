//
//  BSTopOneCollectionViewCell.h
//  Bristol
//
//  Created by Bo on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHighlightButton.h"

#import "BSAvatarButton.h"

@interface BSTopOneCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BSHighlightButton *btnHighlight;
@property (weak, nonatomic) IBOutlet BSAvatarButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *highlightNumLbl;
@property (weak, nonatomic) IBOutlet UIView *multiplyBlendHostView;

@end
