//
//  BSProfilePrivacyViewController.m
//  Bristol
//
//  Created by Bo on 3/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfilePrivacyViewController.h"
#import "BSMeUpdateProfileHttpRequest.h"
#import "BSUserMO.h"
#import "BSEventTracker.h"

#define kOnSwitchColor [UIColor colorWithRed:205/255.f green:240/255.f blue:0.0f alpha:1]

@interface BSProfilePrivacyViewController ()
{
    int _isAllowedComment;
}

@property (weak, nonatomic) IBOutlet UISwitch *profileSwitch;

@end

@implementation BSProfilePrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = ZPLocalizedString(@"PRIVACY SETTINGS").uppercaseString;
	[self.tableView setGlobalUI];
    _profileSwitch.onTintColor = kOnSwitchColor;

    _isAllowedComment = [BSDataManager sharedInstance].currentUser.allow_commentsValue;
    _profileSwitch.on = [BSDataManager sharedInstance].currentUser.is_publicValue;
}

- (IBAction)publicProfileSwitcher:(UISwitch *)sender {
	sender.enabled = NO;
    
    BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest request];
    request.privacy_public_profile = sender.on;
    request.privacy_allow_comments = _isAllowedComment;
	BOOL isPublic = sender.on;
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		sender.enabled = YES;
		[BSEventTracker trackResult:YES eventName:@"switch_profile_privacy" page:self properties:@{@"public":(isPublic?@"yes":@"no")}];
	} failedBlock:^(BSHttpResponseDataModel *result) {
		sender.enabled = YES;
        sender.on = !sender.on;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}


@end
