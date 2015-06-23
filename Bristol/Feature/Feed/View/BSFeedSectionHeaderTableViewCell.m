//
//  BSFeedSectionHeaderTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedSectionHeaderTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSProfileViewController.h"

#import "BSDataManager.h"

@interface BSFeedSectionHeaderTableViewCell()
{
	BSHighlightMO *_highlight;
}

@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UIButton *btnHighlightPlace;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

@end

@implementation BSFeedSectionHeaderTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIView *contentView = [self.subviews firstObject];
	contentView.width = self.width;
	contentView.height = self.height;
	contentView.backgroundColor = [UIColor colorWithRed255:231 green255:231 blue255:231 alphaFloat:.95];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	if (_highlight != highlight) {
		_highlight = highlight;
		
		[_btnHighlightPlace setTitle:_highlight.location_name forState:UIControlStateNormal];
		[_btnTime setTitle:[BSUtility timesAgoOfDate:_highlight.created_at] forState:UIControlStateNormal];
		_lblAuthor.text = _highlight.user.name_id.uppercaseString;
		[_btnAvatar configWithUser:_highlight.user];
	}
}

- (IBAction)btnHighlightPlaceTapped:(id)sender {
	if (_highlight.event) {
		[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithEvent:_highlight.event]];
	}
}

@end
