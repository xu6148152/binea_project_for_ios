//
//  BSLikeTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLikeTableViewCell.h"
#import "BSDataManager.h"

#import "UIControl+EventTrack.h"

@implementation BSLikeTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.cellStyle = BSLikeTableViewCellStyle1;
	_btnLikeInvite.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setCellStyle:(BSLikeTableViewCellStyle)cellStyle {
	_cellStyle = cellStyle;
	if (cellStyle == BSLikeTableViewCellStyle1) {
		_lblStyle1Title.hidden = _lblStyle1SubTitle.hidden = NO;
		_lblStyle2Title.hidden = YES;
	} else {
		_lblStyle1Title.hidden = _lblStyle1SubTitle.hidden = YES;
		_lblStyle2Title.hidden = NO;
	}
}

- (void)configWithUser:(BSUserMO *)user {
	_lblStyle1Title.text = user.name_id.uppercaseString;
	_lblStyle1SubTitle.text = user.name_human_readable;
	_lblStyle2Title.text = user.name_id;
	
	[_btnAvatar configWithUser:user];
	[_btnLikeInvite configWithUser:user];
	_btnAvatar.eventTrackProperties = self.eventTrackProperties;
	_btnLikeInvite.eventTrackProperties = self.eventTrackProperties;
	
	_btnLikeInvite.hidden = ([BSDataManager sharedInstance].currentUser == user);
}

- (void)configWithTeam:(BSTeamMO *)team {
	_lblStyle1Title.text = team.name.uppercaseString;
	_lblStyle1SubTitle.text = team.name;
	_lblStyle2Title.text = team.name.uppercaseString;
	
	[_btnAvatar configWithTeam:team];
	[_btnLikeInvite configWithTeam:team];
	_btnAvatar.eventTrackProperties = self.eventTrackProperties;
	_btnLikeInvite.eventTrackProperties = self.eventTrackProperties;
}

- (void)configWithEvent:(BSEventMO *)event {
	_lblStyle1Title.text = event.name.uppercaseString;
	_lblStyle1SubTitle.text = event.name;
	_lblStyle2Title.text = event.name.uppercaseString;
	
	[_btnAvatar configWithEvent:event];
	[_btnAvatar setImage:[UIImage imageNamed:@"explore_searchresults_events"] forState:UIControlStateNormal];
	[_btnLikeInvite configWithEvent:event];
	_btnAvatar.eventTrackProperties = self.eventTrackProperties;
	_btnLikeInvite.eventTrackProperties = self.eventTrackProperties;
}

@end
