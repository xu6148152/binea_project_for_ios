//
//  BSTeamUserTableViewCell.m
//  Bristol
//
//  Created by Yangfan Huang on 3/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamUserTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSUserMO.h"
#import "BSDataManager.h"

#import "UIControl+EventTrack.h"

@interface BSTeamUserTableViewCell()
@property (weak, nonatomic) IBOutlet BSAvatarButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeButtonRightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *resultBtn;

@property (nonatomic) BSUserMO *user;
@property (nonatomic) BOOL isPendingUser;
@end

@implementation BSTeamUserTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) _configureUser {
	[self.userBtn configWithUser:self.user];
	self.userLabel.text = self.user.name_id.uppercaseString;
	self.nameLabel.text = self.user.name_human_readable;
	self.resultBtn.hidden = YES;
}

- (void) configureCellWithPendingUser:(BSUserMO *)user {
	self.user = user;
	self.isPendingUser = YES;
	
	[self _configureUser];
}

- (void) configureCellWithTeamMember:(BSUserMO *)user {
	self.user = user;
	self.isPendingUser = NO;
	
	[self.acceptBtn removeFromSuperview];
	
	if (user == [BSDataManager sharedInstance].currentUser) {
		self.removeBtn.hidden = YES;
	} else {
		self.removeBtn.hidden = NO;
		self.removeButtonRightConstraint.constant = 10;
	}
	
	[self _configureUser];
}

- (IBAction)btnRemoveTapped:(id)sender {
	self.resultBtn.backgroundColor = [BSUIGlobal negativeColor];
	[self.resultBtn setImage:[UIImage imageNamed:@"capture_x_icon"] forState:UIControlStateNormal];
	self.resultBtn.hidden = NO;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(onRemoveUser:)]) {
		[self.delegate onRemoveUser:self.user];
	}
}

- (IBAction)btnAcceptTapped:(id)sender {
	self.resultBtn.backgroundColor = [BSUIGlobal positiveColor];
	[self.resultBtn setImage:[UIImage imageNamed:@"capture_check_icon"] forState:UIControlStateNormal];
	self.resultBtn.hidden = NO;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(onAcceptUser:)]) {
		[self.delegate onAcceptUser:self.user];
	}
}
@end
