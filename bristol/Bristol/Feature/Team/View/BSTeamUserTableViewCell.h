//
//  BSTeamUserTableViewCell.h
//  Bristol
//
//  Created by Yangfan Huang on 3/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@class BSUserMO;

@protocol BSTeamUserTableViewCellDelegate<NSObject>
@optional
- (void) onRemoveUser:(BSUserMO *)user;
- (void) onAcceptUser:(BSUserMO *)user;
@end

@interface BSTeamUserTableViewCell : BSBaseTableViewCell

- (void) configureCellWithPendingUser:(BSUserMO *)user;
- (void) configureCellWithTeamMember:(BSUserMO *)user;

@property (nonatomic, weak) id<BSTeamUserTableViewCellDelegate> delegate;

@end
