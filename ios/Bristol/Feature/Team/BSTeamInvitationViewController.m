//
//  BSTeamInvitationViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamInvitationViewController.h"

#import "FXBlurView.h"
#import "BSTextField.h"
#import "BSLikeTableViewCell.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

#import "BSTeamPendingInvitationsHttpRequest.h"
#import "BSTeamAllMembersHttpRequest.h"

#import "BSTeamInvitationsDataModel.h"
#import "BSUsersDataModel.h"

#import "BSTeamInviteTableViewDataSource.h"

typedef NS_ENUM (NSUInteger, BSTeamInvitationTab) {
	BSTeamInvitationTabFriends,
	BSTeamInvitationTabSearch,
	BSTeamInvitationTabEmail,
};

@interface BSTeamInvitationViewController () <BSBaseTableViewScrollDelegate, BSTeamInviteEmailDataSourceDelegate>
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet FXBlurView *multiplyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverLeftConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;
@property (weak, nonatomic) IBOutlet BSTextField *searchTextField;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (nonatomic) BSTeamInvitationTab selectedTab;
@property (nonatomic) BSTeamInviteFriendsTableViewDataSource *inviteFriendsDataSource;
@property (nonatomic) BSTeamInviteSearchPeopleTableViewDataSource *inviteSearchPeopleDataSource;
@property (nonatomic) BSTeamInviteEmailTableViewDataSource *inviteEmailDataSource;
@end

@implementation BSTeamInvitationViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Team" bundle:nil] instantiateViewControllerWithIdentifier:@"BSTeamInvitationViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
	
	BSTeamPendingInvitationsHttpRequest *pendingRequest = [BSTeamPendingInvitationsHttpRequest request];
	pendingRequest.teamId = self.team.identifierValue;
	[pendingRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result){
		[self.tableView reloadData];
	} failedBlock:nil];
	
	BSTeamAllMembersHttpRequest *memberRequest = [BSTeamAllMembersHttpRequest request];
	memberRequest.teamId = self.team.identifierValue;
	
	[memberRequest postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		[_tableView reloadData];
	} failedBlock:nil];

	[self.tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	
	[self _selectTab:BSTeamInvitationTabFriends];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		self.multiplyView.dynamic = YES;
	});
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	self.multiplyView.dynamic = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Caution: will trigger tableView reload
- (void) _selectTab:(BSTeamInvitationTab)tab {
	CGFloat left = self.coverLeftConstraint.constant;
	BSTeamInviteTableViewDataSource *dataSource;
	switch (tab) {
		case BSTeamInvitationTabFriends:
			left = self.friendsButton.left;
			if (!self.inviteFriendsDataSource) {
				self.inviteFriendsDataSource = [BSTeamInviteFriendsTableViewDataSource dataSourceWithTeam:self.team];
			}
			dataSource = self.inviteFriendsDataSource;
			self.inviteButton.hidden = YES;
			break;
		case BSTeamInvitationTabSearch:
			if (!self.inviteSearchPeopleDataSource) {
				self.inviteSearchPeopleDataSource = [BSTeamInviteSearchPeopleTableViewDataSource dataSourceWithTeam:self.team];
				self.inviteSearchPeopleDataSource.scrollDelegate = self;
			}
			dataSource = self.inviteSearchPeopleDataSource;
			self.inviteButton.hidden = YES;
			break;
		case BSTeamInvitationTabEmail:
			left = self.mailButton.left;
			if (!self.inviteEmailDataSource) {
				self.inviteEmailDataSource = [BSTeamInviteEmailTableViewDataSource dataSourceWithTeam:self.team];
				self.inviteEmailDataSource.delegate = self;
			}
			dataSource = self.inviteEmailDataSource;
			self.inviteButton.hidden = NO;
			break;
		default:
			return;
	}
	
	if (self.selectedTab != tab && tab != BSTeamInvitationTabSearch) {
		self.selectedTab = tab;
		[UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
			self.coverLeftConstraint.constant = left;
			[self.multiplyView.superview layoutIfNeeded];
		} completion: nil];
	}
	
	if (dataSource) {
		self.tableView.dataSource = dataSource;
		self.tableView.delegate = dataSource;
		[self.tableView reloadData];
	}
}

#pragma mark - Button Tap
- (IBAction)friendsButtonTapped:(id)sender {
	if (self.selectedTab == BSTeamInvitationTabFriends) {
		return;
	}
	
	[self _selectTab:BSTeamInvitationTabFriends];
}

- (IBAction)searchButtonTapped:(id)sender {
	self.searchViewHeightConstraint.constant = 50;
	[self.searchTextField becomeFirstResponder];
	
	[self _selectTab:BSTeamInvitationTabSearch];
}

- (IBAction)mailButtonTapped:(id)sender {
	if (self.selectedTab == BSTeamInvitationTabEmail) {
		return;
	}
	
	[self _selectTab:BSTeamInvitationTabEmail];
}

- (IBAction)inviteButtonTapped:(id)sender {
	[BSUIGlobal showLoadingWithMessage:nil];
	[self.inviteEmailDataSource submitWithSuccess:^{
		[BSUIGlobal hideLoading];
	} faild:^(NSError *error) {
		[BSUIGlobal showMessage:error.localizedDescription];
	}];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (BOOL) textFieldShouldClear:(UITextField *)textField {
	self.searchViewHeightConstraint.constant = 0;
	self.inviteSearchPeopleDataSource.keyword = nil;
	[self.inviteSearchPeopleDataSource clearData];
	[self _selectTab:self.selectedTab];
	return YES;
}

-(void) handleTextChange:(NSNotification *)notification {
	self.inviteSearchPeopleDataSource.keyword = self.searchTextField.text;
	[self.inviteSearchPeopleDataSource refreshDataWithSuccess:nil faild:nil];
}

#pragma mark - BSBaseTableViewScrollDelegate
- (void)tableViewDidScroll:(UITableView *)tableView {
	[self.searchTextField resignFirstResponder];
}

#pragma mark - BSTeamInviteEmailDataSourceDelegate
- (void)dataSource:(BSTeamInviteEmailTableViewDataSource *)dataSource didChangeSubmittable:(BOOL)submittable {
	self.inviteButton.enabled = submittable;
}

#pragma mark - event tracking
- (NSString *) pageName {
	switch (self.selectedTab) {
		case BSTeamInvitationTabSearch:
			return @"team_invite_search";
		case BSTeamInvitationTabEmail:
			return @"team_invite_email";
		case BSTeamInvitationTabFriends:
		default:
			return @"team_invite_friends";
	}
}
@end
