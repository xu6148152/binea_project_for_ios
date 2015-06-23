//
//  BSTeamAvatarEditViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 3/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@class BSTeamMO;

@protocol BSTeamAvatarEditDelegate <NSObject>

- (void) didEditAvatar:(UIImage *)image;

@end

@interface BSTeamAvatarEditViewController : BSBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) BSTeamMO *team;
@property (nonatomic) UIImage *modifiedAvatar;
@property (nonatomic, weak) id<BSTeamAvatarEditDelegate> delegate;

@end
