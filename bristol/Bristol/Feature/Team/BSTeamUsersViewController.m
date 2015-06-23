//
//  BSTeamUsersViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamUsersViewController.h"
#import "BSTeamAcceptApplicationHttpRequest.h"
#import "BSTeamRejectApplicationHttpRequest.h"
#import "BSTeamAllMembersHttpRequest.h"
#import "BSTeamRemoveMemberHttpRequest.h"

#import "BSProfileViewController.h"

@interface BSTeamUsersViewController ()
@property (nonatomic) BOOL isPendingUsers;
@property (nonatomic) NSMutableArray *users;
@property (nonatomic) BSTeamMO *team;
@end

@implementation BSTeamUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (!self.isPendingUsers) {
		[BSUIGlobal showLoadingWithMessage:nil];
		BSTeamAllMembersHttpRequest *memberRequest = [BSTeamAllMembersHttpRequest request];
		memberRequest.teamId = self.team.identifierValue;
		
		[memberRequest postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			[BSUIGlobal hideLoading];
			self.users = [NSMutableArray arrayWithArray:self.team.membersSortedByAlphabet];
			[self.tableView reloadData];
		} failedBlock:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configurePendingUsers:(NSMutableArray *)users ofTeam:(BSTeamMO *)team {
	self.isPendingUsers = YES;
	self.users = users;
	self.team = team;
	self.title = ZPLocalizedString(@"PENDING APPLICATION");
}

- (void) configureMembersWithTeam:(BSTeamMO *)team {
	self.isPendingUsers = NO;
	self.team = team;
	self.users = [NSMutableArray arrayWithArray:self.team.membersSortedByAlphabet];
	self.title = ZPLocalizedString(@"MANAGE TEAM");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.users ? self.users.count : 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSTeamUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSTeamUserTableViewCell.className forIndexPath:indexPath];
	cell.delegate = self;
	
	if (self.isPendingUsers) {
		[cell configureCellWithPendingUser:self.users[indexPath.row]];
	} else {
		[cell configureCellWithTeamMember:self.users[indexPath.row]];
	}
	return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:self.users[indexPath.row]]];
}

#pragma mark - BSTeamUserTableViewCellDelegate
- (void) onRemoveUser:(BSUserMO *)user {
	[self _deleteUserFromTable:user];
	
	if (self.isPendingUsers) {
		[BSEventTracker trackTap:@"reject_application" page:self properties:@{@"team_id":self.team.identifier, @"user_id":user.identifier}];

		BSTeamRejectApplicationHttpRequest *request = [BSTeamRejectApplicationHttpRequest request];
		request.teamId = self.team.identifierValue;
		request.userId = user.identifierValue;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			
		} failedBlock:nil];
	} else {
		[BSEventTracker trackTap:@"remove_member" page:self properties:@{@"team_id":self.team.identifier, @"user_id":user.identifier}];

		BSTeamRemoveMemberHttpRequest *request = [BSTeamRemoveMemberHttpRequest request];
		request.teamId = self.team.identifierValue;
		request.memberId = user.identifierValue;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			self.team.members_countValue--;
		} failedBlock:nil];
		
		[self.team.membersSet removeObject:user];
	}
}

- (void) onAcceptUser:(BSUserMO *)user {
	[BSEventTracker trackTap:@"accept_application" page:self properties:@{@"team_id":self.team.identifier, @"user_id":user.identifier}];
	
	if (!self.isPendingUsers) {
		return;
	}
	
	[self _deleteUserFromTable:user];
	
	BSTeamAcceptApplicationHttpRequest *request = [BSTeamAcceptApplicationHttpRequest request];
	request.teamId = self.team.identifierValue;
	request.userId = user.identifierValue;
	
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		self.team.members_countValue++;
	} failedBlock:nil];
}

- (void) _deleteUserFromTable:(BSUserMO *)user {
	NSUInteger row = [self.users indexOfObject:user];
	if (row == NSNotFound) {
		return;
	}
	
	[self.users removeObject:user];
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	[self.tableView endUpdates];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - event tracking
- (NSString *) pageName {
	return self.isPendingUsers ? @"pending_applications" : @"manage_team_members";
}
@end
