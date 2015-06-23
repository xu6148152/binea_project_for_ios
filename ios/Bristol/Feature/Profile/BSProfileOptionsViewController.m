//
//  BSProfileOptionsViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileOptionsViewController.h"
#import "BSAccountLoginViewController.h"
#import "BSProfileEditViewController.h"

#import "BSEventTracker.h"

@interface BSProfileOptionsViewController ()
{
    NSArray *_users;
}

@end

@implementation BSProfileOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZPLocalizedString(@"OPTIONS");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.row) {
		case 0:
			[BSEventTracker trackTap:@"edit_profile" page:nil properties:nil];
			break;
		case 1:
			[BSEventTracker trackTap:@"create_team" page:nil properties:nil];
			break;
		case 2:
			[BSEventTracker trackTap:@"find_people" page:nil properties:nil];
			break;
		case 3:
			[BSEventTracker trackTap:@"privacy" page:nil properties:nil];
			break;
		case 4:
			[BSEventTracker trackTap:@"logout" page:nil properties:nil];
			break;
		default:
			break;
	}
	
    if (indexPath.row == 4) {
		[BSUIGlobal showActionSheetTitle:nil isDestructive:YES actionTitle:ZPLocalizedString(@"Logout") actionHandler:^{
			[BSEventTracker trackTap:@"confirm_logout" page:nil properties:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotification object:nil];
		}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"BSProfileEditSegue"]) {
		// edit my profile
		((BSProfileEditViewController *)((UINavigationController*)segue.destinationViewController).topViewController).dataType = BSProfileEditDataTypeMeUpdate;
	} else if ([segue.identifier isEqualToString:@"BSTeamEditSegue"]) {
		BSProfileEditViewController *pvc = (BSProfileEditViewController *)((UINavigationController*)segue.destinationViewController).topViewController;
		pvc.dataType = BSProfileEditDataTypeTeamCreate;
	}
}
@end
