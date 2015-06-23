//
//  BSUsersViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUsersViewController.h"
#import "BSProfileViewController.h"
#import "BSLikeTableViewCell.h"

#import "BSHighlightAllLikesTableViewDataSource.h"
#import "BSUserFollowersTableViewDataSource.h"
#import "BSUserFollowingTableViewDataSource.h"

@interface BSUsersViewController ()

@property (nonatomic, strong) BSUserTableViewDataSource *dataSource;

@end

@implementation BSUsersViewController

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Feed" bundle:nil] instantiateViewControllerWithIdentifier:@"BSUsersViewController"];
}

+ (instancetype)instanceOfLikesWithHighlight:(BSHighlightMO *)highlight {
    BSUsersViewController *vc = [self instanceFromStoryboard];
	vc.dataSource = [BSHighlightAllLikesTableViewDataSource dataSourceWithHighlight:highlight];
	vc.title = ZPLocalizedString(@"likes").uppercaseString;
    
    return vc;
}

+ (instancetype)instanceOfFollowersWithUser:(BSUserMO *)user {
    BSUsersViewController *vc = [self instanceFromStoryboard];
	vc.dataSource = [BSUserFollowersTableViewDataSource dataSourceWithUser:user];
	vc.title = ZPLocalizedString(@"FOLLOWERS").uppercaseString;
	vc.pageName = @"profile_followers";
	
    return vc;
}

+ (instancetype)instanceOfFollowingWithUser:(BSUserMO *)user {
	BSUsersViewController *vc = [self instanceFromStoryboard];
	vc.dataSource = [BSUserFollowingTableViewDataSource dataSourceWithUser:user];
	vc.title = ZPLocalizedString(@"FOLLOWING").uppercaseString;
	vc.pageName = @"profile_following";

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(_refreshData:) forControlEvents:UIControlEventValueChanged];
	
	[self.tableView registerNib:[UINib nibWithNibName:BSLikeTableViewCell.className bundle:nil] forCellReuseIdentifier:BSLikeTableViewCell.className];
	self.tableView.dataSource = _dataSource;
	self.tableView.delegate = _dataSource;
}

- (void)_refreshData:(UIRefreshControl *)sender {
    [_dataSource refreshDataWithSuccess:^{
		[self.tableView reloadData];
		[sender endRefreshing];
	} faild:^(NSError *error) {
		[BSUIGlobal showError:error];
		[sender endRefreshing];
	}];
}

@end
