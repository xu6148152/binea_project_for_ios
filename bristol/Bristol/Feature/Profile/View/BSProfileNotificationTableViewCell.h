//
//  BSProfileNotificationTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@class BSNotificationMO;
@class BSProfileNotificationTableViewCell;

@protocol BSProfileNotificationTableViewCellDelegate <NSObject>
- (void)didRemoveNotificationCell:(BSProfileNotificationTableViewCell *)cell;
@end

@interface BSProfileNotificationTableViewCell : BSBaseTableViewCell

@property (nonatomic, weak) id<BSProfileNotificationTableViewCellDelegate> delegate;
@property (nonatomic) BSNotificationMO *notification;

- (void)configWithNotification:(BSNotificationMO *)notification;

@end
