//
//  BSTeamSettingsViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamSettingsViewController.h"
#import "BSTeamSettingsTableViewController.h"
#import "BSTeamDeleteHttpRequest.h"
#import "BSTeamLeaveHttpRequest.h"

#import "UIControl+EventTrack.h"

@interface BSTeamSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation BSTeamSettingsViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Team" bundle:nil] instantiateViewControllerWithIdentifier:@"BSTeamSettingsViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = self.team.name.uppercaseString;
	if (self.team.is_managerValue) {
		[self.actionBtn setTitle:ZPLocalizedString(@"DELETE TEAM") forState:UIControlStateNormal];
		self.actionBtn.eventTrackName = @"delete_team";
	} else {
		[self.actionBtn setTitle:ZPLocalizedString(@"LEAVE") forState:UIControlStateNormal];
		self.actionBtn.eventTrackName = @"leave_team";
	}
	self.actionBtn.eventTrackProperties = @{@"team_id":self.team.identifier};
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)actionBtnTapped:(id)sender {
	ZPVoidBlock actionHandlerDelete = ^ {
		[BSUIGlobal showLoadingWithMessage:nil];
		
		BSTeamDeleteHttpRequest *request = [BSTeamDeleteHttpRequest request];
		request.teamId = self.team.identifierValue;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSUIGlobal hideLoading];
			[[NSNotificationCenter defaultCenter] postNotificationName:kTeamDidRemovedNotification object:self.team];
			
			[self.team deleteEntity];
			[self.navigationController popToRootViewControllerAnimated:YES];
		} failedBlock:nil];
	};
	ZPVoidBlock actionHandlerLeave = ^ {
		[BSUIGlobal showLoadingWithMessage:nil];
		[self.team removeMembersObject:[BSDataManager sharedInstance].currentUser];
		self.team.members_countValue--;
		
		BSTeamLeaveHttpRequest *request = [BSTeamLeaveHttpRequest request];
		request.teamId = self.team.identifierValue;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSUIGlobal hideLoading];
			self.team.is_memberValue = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:self.team];
			[[NSNotificationCenter defaultCenter] postNotificationName:kTeamDidRemovedNotification object:self.team];
			[self.navigationController popViewControllerAnimated:YES];
		} failedBlock:nil];
	};
	NSString *actionSheetTitle = self.team.is_managerValue ? ZPLocalizedString(@"Delete team description") : nil;
	NSString *actionTitle = self.team.is_managerValue ? ZPLocalizedString(@"DELETE THIS TEAM") : ZPLocalizedString(@"LEAVE THIS TEAM");
	ZPVoidBlock actionHandler = self.team.is_managerValue ? actionHandlerDelete : actionHandlerLeave;
	[BSUIGlobal showActionSheetTitle:actionSheetTitle isDestructive:YES actionTitle:actionTitle actionHandler:actionHandler];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
	if ([segue.identifier isEqualToString:@"BSTeamSettingsTableViewSegue"]) {
		BSTeamSettingsTableViewController *destination = (BSTeamSettingsTableViewController *)segue.destinationViewController;
		destination.team = self.team;
	}
}

#pragma mark - event tracking
- (NSString *) useCase {
	return self.team.is_managerValue ? @"manager" : @"member";
}

@end
