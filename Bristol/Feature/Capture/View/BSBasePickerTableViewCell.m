//
//  BSBasePickerTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBasePickerTableViewCell.h"

@interface BSBasePickerTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewIconWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnSoundWidthConstraint;

@end



@implementation BSBasePickerTableViewCell

- (void)awakeFromNib {
	_showSoundButton = YES;
	self.showSoundButton = NO;
    self.showIcon = YES;
	[self setIsHighlight:NO];
}

- (void)setShowIcon:(BOOL)showIcon {
    if (_showIcon != showIcon) {
        _showIcon = showIcon;
        
        _imgViewIconWidthConstraint.constant = showIcon ? _imgViewIcon.height : 0;
    }
}

- (void)setShowSoundButton:(BOOL)showSoundButton {
	if (_showSoundButton != showSoundButton) {
		_showSoundButton = showSoundButton;
		
		_btnSoundWidthConstraint.constant = showSoundButton ? _btnSound.height : 0;
	}
}

- (void)setIsHighlight:(BOOL)highlight {
	self.backgroundColor = highlight ? [BSUIGlobal multiplyBlendColor] : [BSUIGlobal tableViewCellColor];
	_lblTitle.textColor = highlight ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
