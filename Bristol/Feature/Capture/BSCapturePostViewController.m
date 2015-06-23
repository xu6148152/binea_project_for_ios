//
//  BSCapturePostViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCapturePostViewController.h"
#import "BSAddSportsViewController.h"

#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"

@interface BSCapturePostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation BSCapturePostTableViewCell
@end



@interface BSCapturePostAddSportTableViewCell : UITableViewCell
@end

@implementation BSCapturePostAddSportTableViewCell
@end



@interface BSCapturePostViewController ()
{
	NSArray *_sports;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end

#define kCaptureLastSportIdSelected @"kCaptureLastSportIdSelected"
#define kCaptureIsFBSelected @"kCaptureIsFBSelected"
#define kCaptureIsTwitterSelected @"kCaptureIsTwitterSelected"
#define kCaptureIsIGSelected @"kCaptureIsIGSelected"

@implementation BSCapturePostViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Capture" bundle:nil] instantiateViewControllerWithIdentifier:@"BSCapturePostViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Capture" bundle:nil] instantiateViewControllerWithIdentifier:@"BSCapturePostViewControllerNav"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_btnBack.imageView.contentMode = UIViewContentModeCenter;
	_sports = [BSDataManager sharedInstance].currentUser.sportsSortedByAlphabet;
	self.sportSelected = nil;
	NSInteger identify = [UserDefaults integerForKey:kCaptureLastSportIdSelected];
	for (BSSportMO *sport in _sports) {
		if ((NSInteger)sport.identifierValue == identify) {
			self.sportSelected = sport;
			break;
		}
	}
	
	if ([ZPFacebookSharer isConnected] && [UserDefaults boolForKey:kCaptureIsFBSelected]) {
		_btnShareWithFB.selected = YES;
	}
	if ([ZPTwitterSharer isConnected] && [UserDefaults boolForKey:kCaptureIsTwitterSelected]) {
		_btnShareWithTwitter.selected = YES;
	}
	if ([ZPInstagramSharer isInstalled] && [UserDefaults boolForKey:kCaptureIsIGSelected]) {
		_btnShareWithIG.selected = YES;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_sports = [BSDataManager sharedInstance].currentUser.sportsSortedByAlphabet;
	if (![_sports containsObject:self.sportSelected]) {
		self.sportSelected = nil;
	}
	[self.tableView reloadData];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (_sportSelected) {
		[UserDefaults setInteger:(NSInteger)_sportSelected.identifierValue forKey:kCaptureLastSportIdSelected];
	}
	[UserDefaults setBool:_btnShareWithFB.selected forKey:kCaptureIsFBSelected];
	[UserDefaults setBool:_btnShareWithTwitter.selected forKey:kCaptureIsTwitterSelected];
	[UserDefaults setBool:_btnShareWithIG.selected forKey:kCaptureIsIGSelected];
}

- (void)dealloc {
	
}

- (IBAction)btnBackTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	ZPInvokeBlock(_backButtonTappedBlock);
}

- (void)setSportSelected:(BSSportMO *)sportSelected {
	_sportSelected = sportSelected;
	_btnPost.enabled = _sportSelected != nil;
}

- (IBAction)btnShareWithFBTapped:(BSActivityIndicatorButton *)sender {
	if ([ZPFacebookSharer isConnected]) {
		sender.selected = !sender.selected;
	} else {
		[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site confirm format"), @"Facebook"] actionTitle:ZPLocalizedString(@"Sure") actionHandler:^{
			sender.enabled = NO;
			[sender showActivityIndicator:YES];
			[ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
				sender.enabled = YES;
				sender.selected = !sender.selected;
				[sender showActivityIndicator:NO];
			} faildHandler:^(NSError *error) {
				sender.enabled = YES;
				[sender showActivityIndicator:NO];
				[BSUIGlobal showError:error];
			}];
		}];
	}
}

- (IBAction)btnShareWithTwitterTapped:(BSActivityIndicatorButton *)sender {
	if ([ZPTwitterSharer isConnected]) {
		sender.selected = !sender.selected;
	} else {
		[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site confirm format"), @"Twitter"] actionTitle:ZPLocalizedString(@"Sure") actionHandler:^{
			sender.enabled = NO;
			[sender showActivityIndicator:YES];
			[ZPTwitterSharer connectWithSuccessHandler:^(NSString *authToken, NSString *authTokenSecret) {
				sender.enabled = YES;
				sender.selected = !sender.selected;
				[sender showActivityIndicator:NO];
			} faildHandler:^(NSError *error) {
				sender.enabled = YES;
				[sender showActivityIndicator:NO];
				[BSUIGlobal showError:error];
			}];
		}];
	}
}

- (IBAction)btnShareWithIGTapped:(UIButton *)sender {
	if ([ZPInstagramSharer isInstalled]) {
		sender.selected = !sender.selected;
	} else {
		[BSUIGlobal showMessage:ZPLocalizedString(@"Instagram not installed")];
	}
}

- (IBAction)btnPostTapped:(id)sender {
	ZPInvokeBlock(self.postButtonTappedBlock, sender);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _sports.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == _sports.count) {
		return [tableView dequeueReusableCellWithIdentifier:BSCapturePostAddSportTableViewCell.className forIndexPath:indexPath];
	} else {
		BSCapturePostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCapturePostTableViewCell.className forIndexPath:indexPath];
		BSSportMO *sportDataModel = [_sports objectAtIndex:indexPath.row];
		cell.lblTitle.text = sportDataModel.nameLocalized;
		
		if (sportDataModel == self.sportSelected) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == _sports.count) {
		[self.navigationController pushViewController:[BSAddSportsViewController instanceFromStoryboard] animated:YES];
	} else {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		BSSportMO *sportDataModel = [_sports objectAtIndex:indexPath.row];
		if (self.sportSelected && self.sportSelected != sportDataModel) {
			NSUInteger index = [_sports indexOfObject:self.sportSelected];
			UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
			cellSelected.accessoryType = UITableViewCellAccessoryNone;
		}
		self.sportSelected = sportDataModel;
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

@end
