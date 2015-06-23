//
//  BSHighlightEffectCollectionViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightEffectCollectionViewCell.h"
#import "BSHighlightBaseEffectModel.h"

@interface BSHighlightEffectCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end


@implementation BSHighlightEffectCollectionViewCell

- (void)_commitInit {
	self.selected = NO;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _commitInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _commitInit];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
	self.contentView.backgroundColor = selected ? [UIColor clearColor] : [UIColor blackColor];
    _lblTitle.highlighted = _imgViewIcon.highlighted = selected;
}

- (void)configWithHighlightEffectModel:(BSHighlightBaseEffectModel *)model {
    _imgViewIcon.image = [UIImage imageNamed:model.iconNormal];
    _imgViewIcon.highlightedImage = [UIImage imageNamed:model.iconHighlight];
    _lblTitle.text = model.name;
}

@end
