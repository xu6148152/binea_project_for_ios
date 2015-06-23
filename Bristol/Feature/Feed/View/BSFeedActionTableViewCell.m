//
//  BSFeedActionTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedActionTableViewCell.h"
#import "BSDataManager.h"

#import "BSUsersViewController.h"

@interface BSFeedActionTableViewCell ()
{
//	BSCustomHttpRequest *_request;
}

@property (weak, nonatomic) IBOutlet UIButton *btnViews;
@property (weak, nonatomic) IBOutlet UIButton *btnLikes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorViewHeightConstraint;

@end


@implementation BSFeedActionTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_seperatorViewHeightConstraint.constant = 0.5;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	NSParameterAssert([highlight isKindOfClass:[BSHighlightMO class]]);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kHighlightLikeDidChangedNotification object:_highlight];
	_highlight = highlight;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_likeDidChangedNotification) name:kHighlightLikeDidChangedNotification object:_highlight];
	
	[_btnViews setTitle:[NSString stringWithFormat:@"%@ %@", _highlight.played_times.stringValue, ZPLocalizedString(@"views")] forState:UIControlStateNormal];
	[self _updateLikeUI];
}

- (void)_updateLikeUI {
	[_btnLikes setTitle:[NSString stringWithFormat:@"%@ %@", _highlight.likes_count.stringValue, ZPLocalizedString(@"likes")] forState:UIControlStateNormal];
}

- (void)_likeDidChangedNotification {
	[self _updateLikeUI];
}

- (IBAction)btnLikesTapped:(UIButton *)sender {
	[BSUtility pushViewController:[BSUsersViewController instanceOfLikesWithHighlight:_highlight]];
}

@end
