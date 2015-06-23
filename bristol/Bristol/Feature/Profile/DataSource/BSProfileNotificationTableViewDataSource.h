//
//  BSProfileNotificationTableViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileBaseTableViewDataSource.h"

#define kTeamDidIgnoreOrAcceptInvitationNotification @"kTeamDidIgnoreOrAcceptInvitationNotification"

@interface BSProfileNotificationTableViewDataSource : BSProfileBaseTableViewDataSource

@property (nonatomic, strong, readonly) NSArray *notificationsNewer;
@property (nonatomic, strong, readonly) NSArray *notificationsOlder;

@end
