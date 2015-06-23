//
//  BSBaseTableViewCell.m
//  Bristol
//
//  Created by Bo on 1/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@implementation BSBaseTableViewCell

- (void)awakeFromNib {
	self.selectionStyle = kShowHighlightWhenTapDown ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end
