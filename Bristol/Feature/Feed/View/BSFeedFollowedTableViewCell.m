//
//  BSFeedFollowedTableViewCell.m
//  Bristol
//
//  Created by Bo on 4/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedFollowedTableViewCell.h"

@implementation BSFeedFollowedTableViewCell

- (void)awakeFromNib {

}

- (void)configWithUser:(BSUserMO *)user
{
    [_avatarBtn configWithUser:user];
    [_lblID setText:user.name_id];
    [_lblName setText:user.name_human_readable];
    
}
@end
