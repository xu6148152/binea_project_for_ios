//
//  BSCaptureChooseSportViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCaptureChooseSportViewController.h"
#import "BSAddSportsViewController.h"

@interface BSCaptureChooseSportViewController ()

@property (weak, nonatomic) IBOutlet UIView *addSportsView;

@end

@implementation BSCaptureChooseSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.tableFooterView = _addSportsView;
}

- (void)viewWillAppear:(BOOL)animated {
	[self reloadData];
	
	[super viewWillAppear:animated];
}

#pragma mark - over write
- (NSArray *)getObjectsToBind {
    return [BSDataManager sharedInstance].currentUser.sportsSortedByAlphabet;
}

- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(NSObject *)object {
    if (object) {
        BSSportMO *sport = (BSSportMO *)object;
        cell.lblTitle.text = sport.nameLocalized.uppercaseString;
    } else {
        cell.lblTitle.text = ZPLocalizedString(@"No Sport");
    }
    cell.showIcon = NO;
}

- (IBAction)btnAddSportsTapped:(id)sender {
	BSAddSportsViewController *vc = [BSAddSportsViewController instanceFromStoryboardWithUser:[BSDataManager sharedInstance].currentUser];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
