//
//  BSProfileAllowCommentsViewController.m
//  Bristol
//
//  Created by Bo on 3/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileAllowCommentsViewController.h"
#import "BSMeUpdateProfileHttpRequest.h"
#import "BSUserMO.h"

@interface BSProfileAllowCommentsViewController ()
{
    int _isAllowedComment;
    BOOL _isPublicProfile;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *everyoneTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *peopleFollowTableViewCell;

@end

@implementation BSProfileAllowCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZPLocalizedString(@"ALLOW COMMENTS");
    
    _isAllowedComment = [BSDataManager sharedInstance].currentUser.allow_commentsValue;
    _isPublicProfile = [BSDataManager sharedInstance].currentUser.is_publicValue;
    
    if (_isAllowedComment == 1) {
        _everyoneTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _peopleFollowTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        _everyoneTableViewCell.accessoryType = UITableViewCellAccessoryNone;
        _peopleFollowTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == _everyoneTableViewCell) {
        _everyoneTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _peopleFollowTableViewCell.accessoryType = UITableViewCellAccessoryNone;
        _isAllowedComment = 1;
    } else {
        _everyoneTableViewCell.accessoryType = UITableViewCellAccessoryNone;
        _peopleFollowTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _isAllowedComment = 2;
    }
	
	if ([BSDataManager sharedInstance].currentUser.allow_commentsValue != _isAllowedComment) {
		BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest request];
		request.user_id = [BSDataManager sharedInstance].currentUser.identifierValue;
		request.privacy_allow_comments = _isAllowedComment;
		request.privacy_public_profile = _isPublicProfile;
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:YES eventName:@"allow_comment" page:self properties:@{@"scope": (_isAllowedComment == 2 ? @"following":@"everyone")}];
			[BSDataManager sharedInstance].currentUser.allow_commentsValue = _isAllowedComment;
			[[BSDataManager sharedInstance] save];
			
		} failedBlock:nil];
	}
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

@end
