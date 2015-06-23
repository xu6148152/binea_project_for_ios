//
//  BSFollowPeopleTableViewCell.h
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAvatarButton.h"
#import "BSLikeOrInviteButton.h"

#import "BSUserMO.h"

@interface BSFollowPeopleTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) BSUserMO *user;
@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet BSLikeOrInviteButton *btnFollow;
@property (weak, nonatomic) IBOutlet UICollectionView *highlightCollectionView;
@property (nonatomic, strong) NSArray *userHighlightAry;

@end
