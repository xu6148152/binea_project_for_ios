//
//  BSFeedFollowedTableViewCell.h
//  Bristol
//
//  Created by Bo on 4/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAvatarButton.h"
#import "BSUserMO.h"

@interface BSFeedFollowedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BSAvatarButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

- (void)configWithUser:(BSUserMO *)user;


@end
