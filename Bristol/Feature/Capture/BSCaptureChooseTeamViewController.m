//
//  BSCaptureChooseTeamViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCaptureChooseTeamViewController.h"
#import "BSUserTeamsHttpRequest.h"

@interface BSCaptureChooseTeamViewController ()
@end

@implementation BSCaptureChooseTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = ZPLocalizedString(@"Tap to tag team").uppercaseString;
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(_refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self _pulldownRefresh];
}

- (void)_refresh {
	BSUserTeamsHttpRequest *request = [BSUserTeamsHttpRequest request];
	request.user_id = [BSDataManager sharedInstance].currentUser.identifierValue;
	[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		[self reloadData];
		[self.refreshControl endRefreshing];
	} failedBlock:^(BSHttpResponseDataModel *result) {
		[self.refreshControl endRefreshing];
	}];
}

- (void)_pulldownRefresh {
	[self.refreshControl beginRefreshing];
	float additionalHeight = [UIApplication sharedApplication].statusBarHidden ? 0 : [UIApplication sharedApplication].statusBarFrame.size.height;
	additionalHeight += self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.height;
	[self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.height - additionalHeight) animated:YES];
	
	[self _refresh];
}

#pragma mark - over write
- (NSArray *)getObjectsToBind {
    NSArray *teams = [[BSDataManager sharedInstance].currentUser.joined_teams sortedArrayWithKey:@"created_at" ascending:NO];
	
    return teams;
}

- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(NSObject *)object {
    if (object) {
        BSTeamMO *team = (BSTeamMO *)object;
        cell.lblTitle.text = team.name.uppercaseString;
        [cell.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:team.avatar_url] placeholderImage:[UIImage imageNamed:@"common_teamdefaulticon_small"]];
        cell.showIcon = YES;
    } else {
        cell.lblTitle.text = ZPLocalizedString(@"No Team").uppercaseString;
        cell.showIcon = NO;
    }
}

@end
