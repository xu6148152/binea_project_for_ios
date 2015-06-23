//
//  BSTeamSettingsTableViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamSettingsTableViewController.h"
#import "BSTeamUpdatePrivateHttpRequest.h"
#import "BSTeamUpdateJoinableHttpRequest.h"
#import "BSTeamPendingApplicationsHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSTeamUsersViewController.h"
#import "BSTeamInvitationViewController.h"
#import "BSProfileEditViewController.h"

#import "UIControl+EventTrack.h"

#define kOnSwitchColor [UIColor colorWithRed:205/255.f green:240/255.f blue:0.0f alpha:1]

@interface BSTeamSettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *joinableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *privateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;

@property NSMutableArray *pendingUsers;

@end

@implementation BSTeamSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.pendingUsers = [[NSMutableArray alloc] init];
    
    self.joinableSwitch.onTintColor = kOnSwitchColor;
    self.privateSwitch.onTintColor = kOnSwitchColor;
	
	[self _configSwitches];
	[self _reloadPendingUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// 	[self _reloadPendingUsers];
	[self.tableView reloadData];
}

- (void) _configSwitches {
	if (self.team) {
		self.joinableSwitch.on = self.team.is_joinableValue;
		self.privateSwitch.on = self.team.is_privateValue;
	}
}

- (void) _reloadPendingUsers {
	BSTeamPendingApplicationsHttpRequest *request = [BSTeamPendingApplicationsHttpRequest request];
	request.teamId = self.team.identifierValue;
	
	[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		NSArray *users = ((BSUsersDataModel *)result.dataModel).users;
		
		if (users) {
			self.pendingUsers = [NSMutableArray arrayWithArray:users];
			self.pendingLabel.text = [NSString stringWithFormat:@"%@", @(self.pendingUsers.count)];
			[self.tableView reloadData];
		}
	} failedBlock:nil];
}

- (IBAction)joinableSwitchChanged:(id)sender {
	self.team.is_joinableValue = self.joinableSwitch.on;
	
	BSTeamUpdateJoinableHttpRequest *request = [BSTeamUpdateJoinableHttpRequest request];
	request.teamId = self.team.identifierValue;
	request.joinable = self.team.is_joinableValue;
	
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		self.team = (BSTeamMO *)result.dataModel;
		[BSEventTracker trackResult:YES eventName:@"switch_joinable" page:nil properties:@{@"joinable":self.team.is_joinableValue?@"yes":@"no", @"team_id":self.team.identifier}];
		[self _configSwitches];
	} failedBlock:^(BSHttpResponseDataModel *result) {
		self.team.is_joinableValue = !self.team.is_joinableValue;
		self.joinableSwitch.on = self.team.is_joinableValue;
	}];
}


- (IBAction)privateSwitchChanged:(id)sender {
	self.team.is_privateValue = self.privateSwitch.on;
	
	BSTeamUpdatePrivateHttpRequest *request = [BSTeamUpdatePrivateHttpRequest request];
	request.teamId = self.team.identifierValue;
	request.isPrivate = self.team.is_privateValue;
	
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		self.team = (BSTeamMO *)result.dataModel;
		[BSEventTracker trackResult:YES eventName:@"switch_private" page:nil properties:@{@"private":self.team.is_privateValue?@"yes":@"no", @"team_id":self.team.identifier}];
		[self _configSwitches];
	} failedBlock:^(BSHttpResponseDataModel *result) {
		self.team.is_privateValue = !self.team.is_privateValue;
		self.privateSwitch.on = self.team.is_privateValue;
	}];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		// pending application
		UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
		if (self.pendingUsers.count == 0) {
			if (cell) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return 0;
		} else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return 63;
		}
	}

	if (self.team.is_manager != nil && self.team.is_managerValue) {
		if (indexPath.row == 4) {
			self.joinableSwitch.hidden = NO;
		}
		if (indexPath.row == 6) {
			self.privateSwitch.hidden = NO;
		}
		return 63;
	}
	
	switch (indexPath.row) {
		case 1:
		case 2:
			return 63;
		case 3:
		{
			UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
			if (cell) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			return 0;
		}
		case 4:
			self.joinableSwitch.hidden = YES;
			return 0;
		case 6:
			self.privateSwitch.hidden = YES;
			return 0;
		default:
			return 0;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	switch (indexPath.row) {
		case 0:
		{
			[BSEventTracker trackTap:@"edit_team" page:nil properties:@{@"team_id":self.team.identifier}];
			UINavigationController *nvc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileEditNavigationViewController"];
			
			BSProfileEditViewController *vc = (BSProfileEditViewController *)nvc.topViewController;
			vc.dataType = BSProfileEditDataTypeTeamUpdate;
			vc.team = self.team;
			
			[self presentViewController:nvc animated:YES completion:nil];
		}
			break;
		case 1:
			[BSEventTracker trackTap:@"pending_application" page:nil properties:@{@"team_id":self.team.identifier, @"pendings":@(self.pendingUsers.count)}];
			break;
		case 2:
			[BSEventTracker trackTap:@"team_invite" page:nil properties:@{@"team_id":self.team.identifier}];
			break;
		case 3:
			[BSEventTracker trackTap:@"manage_member" page:nil properties:@{@"team_id":self.team.identifier}];
			break;
		default:
			break;
	}
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
	if ([segue.identifier isEqualToString:@"BSTeamPendingApplicationsSegue"]) {
		BSTeamUsersViewController *destination = (BSTeamUsersViewController *)segue.destinationViewController;
		[destination configurePendingUsers:self.pendingUsers ofTeam:self.team];
	} else if ([segue.identifier isEqualToString:@"BSTeamMembersSegue"]) {
		BSTeamUsersViewController *destination = (BSTeamUsersViewController *)segue.destinationViewController;
		[destination configureMembersWithTeam:self.team];
	} else if ([segue.identifier isEqualToString:@"BSTeamInvitationSegue"]) {
		BSTeamInvitationViewController *destination = (BSTeamInvitationViewController *)segue.destinationViewController;
		destination.team = self.team;
	}
}
@end
