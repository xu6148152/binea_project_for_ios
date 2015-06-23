//
//  BSProfileTeamTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "BSDataModels.h"
#import "BSLikeOrInviteButton.h"

@interface BSProfileTeamTableViewCell : BSBaseTableViewCell

@property (weak, nonatomic) IBOutlet BSLikeOrInviteButton *btnFollow;

- (void)configWithTeam:(BSTeamMO *)team;
- (void)configWithEvent:(BSEventMO *)event;
- (void)configWithData:(id)data; // BSTeamMO or BSEventMO

@property (nonatomic) NSDictionary *eventTrackProperties;
@end
