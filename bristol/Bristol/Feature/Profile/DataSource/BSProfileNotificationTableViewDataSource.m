//
//  BSProfileNotificationTableViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileNotificationTableViewDataSource.h"
#import "BSMeNotificationHttpRequest.h"
#import "BSNotificationsDataModel.h"
#import "BSNotificationMO.h"

#import "BSProfileNotificationTableViewCell.h"
#import "BSUIGlobal.h"

#import "NSDate+Utilities.h"

@interface BSProfileNotificationTableViewDataSource()<BSProfileNotificationTableViewCellDelegate>
{
	NSMutableArray *_notificationsNewer, *_notificationsOlder;
}
@end

@implementation BSProfileNotificationTableViewDataSource
@synthesize notificationsNewer = _notificationsNewer, notificationsOlder = _notificationsOlder;

- (instancetype) initWithUserMO:(BSUserMO *)user {
	if (self = [super initWithUserMO:user]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didIgnoreOrAcceptTeamInvitation:) name:kTeamDidIgnoreOrAcceptInvitationNotification object:nil];
	}
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kTeamDidIgnoreOrAcceptInvitationNotification object:nil];
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	BSMeNotificationHttpRequest *request = [BSMeNotificationHttpRequest request];
	request.user_id = self.user.identifierValue;
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		BSNotificationsDataModel *dm = (BSNotificationsDataModel *)result.dataModel;
		_notificationsNewer = [NSMutableArray array];
		_notificationsOlder = [NSMutableArray array];
		for (BSNotificationMO *notification in dm.notifications) {
			if ([notification.created_at isLaterThanDate:dm.last_read_date]) {
				[_notificationsNewer addObject:notification];
			} else
				[_notificationsOlder addObject:notification];
		}
		
		[_tableView reloadData];
		ZPInvokeBlock(success);
	} failedBlock: ^(BSHttpResponseDataModel *result) {
		ZPInvokeBlock(faild, result.error);
	}];
}

- (void)didIgnoreOrAcceptTeamInvitation:(NSNotification *)note {
	BSTeamMO *team = note.object;
	NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
	
	for (int i = 0; i < _notificationsNewer.count; i++) {
		BSNotificationMO *notification = _notificationsNewer[i];
		if (notification.notification_typeValue == BSNotificationTypeTeamInviteMeToJoin && notification.team == team) {
			[indexSet addIndex:i];
		}
	}
	[_notificationsNewer removeObjectsAtIndexes:indexSet];
	
	[indexSet removeAllIndexes];
	for (int i = 0; i < _notificationsOlder.count; i++) {
		BSNotificationMO *notification = _notificationsOlder[i];
		if (notification.notification_typeValue == BSNotificationTypeTeamInviteMeToJoin && notification.team == team) {
			[indexSet addIndex:i];
		}
	}
	[_notificationsOlder removeObjectsAtIndexes:indexSet];
	if (_tableView.dataSource == self) {
		[_tableView reloadData];
	}
}

- (BOOL)_isTwoSection {
	return _notificationsNewer.count > 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self _isTwoSection]) {
		return 2;
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	_tableView = tableView;
	
	if ([self _isTwoSection] && section == 0) {
		return _notificationsNewer.count;
	} else {
		return _notificationsOlder.count;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self _isTwoSection]) {
		if (section == 0) {
			return _notificationsNewer.count > 0 ? 22 : 0;
		} else {
			return _notificationsOlder.count > 0 ? 22 : 0;
		}
	} else {
		return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([self _isTwoSection]) {
		NSString *title = nil;
		if (section == 0) {
			title = ZPLocalizedString(@"New");
		} else {
			title = ZPLocalizedString(@"Older");
		}
		
		return [BSUIGlobal createCommonTableViewSectionHeaderWithTitle:title];
	} else {
		return nil;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSProfileNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSProfileNotificationTableViewCell.className];
	BSNotificationMO *notification;
	if ([self _isTwoSection] && indexPath.section == 0) {
		notification = _notificationsNewer[indexPath.row];
	} else {
		notification = _notificationsOlder[indexPath.row];
	}
	cell.delegate = self;
	[cell configWithNotification:notification];
	
	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 66;
}

#pragma mark - BSProfileNotificationTableViewCellDelegate
- (void)didRemoveNotificationCell:(BSProfileNotificationTableViewCell *)cell{
	NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
	BOOL newer = NO;
	
	if (indexPath) {
		if ([self _isTwoSection] && indexPath.section == 0) {
			[_notificationsNewer removeObjectAtIndex:indexPath.row];
			newer = YES;
		} else {
			[_notificationsOlder removeObjectAtIndex:indexPath.row];
		}
		
		[_tableView beginUpdates];
		[_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
		if (newer && _notificationsNewer.count == 0) {
			[_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
			
		}
		[_tableView endUpdates];
	}
}
@end
