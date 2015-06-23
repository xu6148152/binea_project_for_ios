//
//  BSTeamInviteTableViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 3/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUserTableViewDataSource.h"
#import "BSEmailFieldTableViewCell.h"

@class BSTeamMO;

@interface BSTeamInviteTableViewDataSource : BSUserTableViewDataSource
{
	BSTeamMO *_team;
}

- (instancetype) initWithTeam:(BSTeamMO *)team;
@end



@interface BSTeamInviteFriendsTableViewDataSource : BSTeamInviteTableViewDataSource
+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team;
@end


@interface BSTeamInviteSearchPeopleTableViewDataSource : BSTeamInviteTableViewDataSource
+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team;

@property (nonatomic) NSString *keyword;

- (void) clearData;
@end


@class BSTeamInviteEmailTableViewDataSource;

@protocol BSTeamInviteEmailDataSourceDelegate <NSObject>
- (void)dataSource:(BSTeamInviteEmailTableViewDataSource*)dataSource didChangeSubmittable:(BOOL)submittable;
@end

@interface BSTeamInviteEmailTableViewDataSource : BSTeamInviteTableViewDataSource
+ (instancetype) dataSourceWithTeam:(BSTeamMO *)team;

@property (nonatomic, weak) id<BSTeamInviteEmailDataSourceDelegate> delegate;

- (void) submitWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild;
@end