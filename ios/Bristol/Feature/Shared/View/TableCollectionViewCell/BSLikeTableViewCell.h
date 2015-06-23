//
//  BSLikeTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSLikeOrInviteButton.h"
#import "BSDataModels.h"

typedef NS_ENUM(NSInteger, BSLikeTableViewCellStyle) {
	BSLikeTableViewCellStyle1, // two lables
	BSLikeTableViewCellStyle2  // one label
};

@interface BSLikeTableViewCell : BSBaseTableViewCell

@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet BSLikeOrInviteButton *btnLikeInvite;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle1Title;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle1SubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle2Title;

@property (assign, nonatomic) BSLikeTableViewCellStyle cellStyle; // default is BSLikeTableViewCellStyle1
@property (strong, nonatomic) id userData;

@property (nonatomic) NSDictionary *eventTrackProperties;

- (void)configWithUser:(BSUserMO *)user;
- (void)configWithTeam:(BSTeamMO *)team;
- (void)configWithEvent:(BSEventMO *)event;

@end
