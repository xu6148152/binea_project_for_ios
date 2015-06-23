//
//  BSAddSportsViewController.m
//  Bristol
//
//  Created by Bo on 2/28/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAddSportsViewController.h"

#import "BSMeUpdateProfileHttpRequest.h"
#import "BSTeamUpdateHttpRequest.h"

@interface BSAddSportsViewController ()
{
	NSArray *_sportsAll;
	NSSet *_sportsOrginal;
}

@property (nonatomic, strong) BSUserMO *user;
@property (nonatomic, strong) BSTeamMO *team;

@end

@implementation BSAddSportsViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"TopTen" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAddSportsViewController"];
}

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user {
	NSParameterAssert([user isKindOfClass:[BSUserMO class]]);
	
	BSAddSportsViewController *vc = [BSAddSportsViewController instanceFromStoryboard];
	vc.user = user;
	return vc;
}

+ (instancetype)instanceFromStoryboardWithTeam:(BSTeamMO *)team {
	NSParameterAssert([team isKindOfClass:[BSTeamMO class]]);
	
	BSAddSportsViewController *vc = [BSAddSportsViewController instanceFromStoryboard];
	vc.team = team;
	return vc;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	_autoSyncWithServer = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = NO;
	self.title = ZPLocalizedString(@"ADD SPORTS").uppercaseString;
	
	if (!_user && !_team) {
        _user = [self _getCurrentUser];
	}
	_sportsOrginal = [self _getSportsOfDataModel];
	
	_sportsAll = [[BSSportMO findAll] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		if (((BSSportMO *)obj1).identifierValue == 0x400) {
			return NSOrderedDescending;
		}
		if (((BSSportMO *)obj2).identifierValue == 0x400) {
			return NSOrderedAscending;
		}
		
		return [((BSSportMO *)obj1).nameLocalized compare:((BSSportMO *)obj2).nameLocalized];
	}];
    
    if ([BSUtility getPopUpFirstActionDate:kFirstAddSportsDate] == nil) {
        [BSUtility savePopUpFirstActionDate:[NSDate date] withKey:kFirstAddSportsDate];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (_autoSyncWithServer) {
		NSSet *sportsNow = [self _getSportsOfDataModel];
		if (![sportsNow isEqualToSet:_sportsOrginal]) {
			if (_user) {
				BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest request];
				request.user_id = _user.identifierValue;
				request.sports = [BSUtility formatSportsId:_user.sports];
				[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
					
				} failedBlock:nil];
			} else {
				BSTeamUpdateHttpRequest *request = [BSTeamUpdateHttpRequest request];
				request.teamId = _team.identifierValue;
				request.sports = [BSUtility formatSportsId:_team.sports];
				[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
					
				} failedBlock:nil];
			}
		}
	}
}

- (NSSet *)_getSportsOfDataModel {
	if (_user) {
		return [_user.sports copy];
	} else {
		return [_team.sports copy];
	}
}

- (BOOL)_containsSport:(BSSportMO *)sport {
	if (_user) {
		return [_user.sports containsObject:sport];
	} else {
		return [_team.sports containsObject:sport];
	}
}

- (void)_addSport:(BSSportMO *)sport {
	if (_user) {
		[_user addSportsObject:sport];
	} else {
		[_team addSportsObject:sport];
	}
}

- (void)_removeSport:(BSSportMO *)sport {
	if (_user) {
		[_user removeSportsObject:sport];
	} else {
		[_team removeSportsObject:sport];
	}
}

- (BSUserMO *)_getCurrentUser {
    return [BSDataManager sharedInstance].currentUser;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sportsAll.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"addSportsCellId" forIndexPath:indexPath];
    BSSportMO *sportDataModel = [_sportsAll objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-BlackOblique" size:18.0f]];
    [cell.textLabel setText:sportDataModel.nameLocalized.uppercaseString];
    
    if ([self _containsSport:sportDataModel]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BSSportMO *sportDataModel = [_sportsAll objectAtIndex:indexPath.row];
	if (![self _containsSport:sportDataModel]) {
		[self _addSport:sportDataModel];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
		[self _removeSport:sportDataModel];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
