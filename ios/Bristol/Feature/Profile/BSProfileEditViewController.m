//
//  BSProfileEditViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileEditViewController.h"

#import "BSMeProfileHttpRequest.h"
#import "BSMeUpdateProfileHttpRequest.h"
#import "BSTeamCreateHttpRequest.h"
#import "BSTeamUpdateHttpRequest.h"
#import "BSUserMO.h"
#import "UIButton+WebCache.h"

#import "BSAddSportsViewController.h"
#import "BSTeamAvatarEditViewController.h"
#import "BSMapAnnotation.h"
#import "BSTeamLocationViewController.h"

#import "BSTeamSettingsViewController.h"
#import "BSTeamInvitationViewController.h"
#import "BSProfileViewController.h"

#define InvalidDegree 361

@interface BSProfileEditViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSLocationViewControllerDelegate, BSTeamAvatarEditDelegate, UITextFieldDelegate>
{
	UIImage *_avatarPicked;
	NSSet *_sportsBackup;
}
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *dashImg;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *nameLockImg;
@property (weak, nonatomic) IBOutlet UIImageView *userIDLockImg;
@property (weak, nonatomic) IBOutlet UILabel *userIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIImageView *emailLockImg;
@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UIButton *teamAvatarBtn;

@property (nonatomic) NSString *location;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation BSProfileEditViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ZPLocalizedString(@"REQUIRED") attributes:@{NSForegroundColorAttributeName: [BSUIGlobal placeholderColor]}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange:) name:UITextFieldTextDidChangeNotification object:_nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	switch (_dataType) {
		case BSProfileEditDataTypeMeUpdate:
			self.title = ZPLocalizedString(@"EDIT PROFILE");
			_user = [BSDataManager sharedInstance].currentUser;
			[self updateUIWithUser:_user];
			
            if (_dataType == BSProfileEditDataTypeMeUpdate) {
                 BSMeProfileHttpRequest *request = [BSMeProfileHttpRequest request];
                request.user_id = _user.identifierValue;
                [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
                    BSUserMO *user = (BSUserMO *)result.dataModel;
                    [self updateUIWithUser:user];
                } failedBlock:^(BSHttpResponseDataModel *result) {
                    [self updateUIWithUser:nil];
                }];
            }
           
			_sportsBackup = [NSSet setWithSet:_user.sports];
			_sportTitleLbl.text = ZPLocalizedString(@"Favourite Sports");
			[self drawAvatarDashLine];
			break;
		case BSProfileEditDataTypeTeamCreate:
		case BSProfileEditDataTypeTeamUpdate:
			[_avatarBtn removeFromSuperview];
            [_userIDLockImg removeFromSuperview];
            [_emailLockImg removeFromSuperview];
			_sportTitleLbl.text = ZPLocalizedString(@"Sports");
			_teamAvatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
			_coordinate = CLLocationCoordinate2DMake(InvalidDegree, InvalidDegree);
			if (_dataType == BSProfileEditDataTypeTeamUpdate) {
				self.title = ZPLocalizedString(@"EDIT TEAM PROFILE");
				_sportsBackup = [NSSet setWithSet:_team.sports];
				
				_nameTextField.enabled = NO;
				_nameTextField.text = _team.name;
				_nameTextField.textColor = [BSUIGlobal placeholderColor];
				_nameLockImg.hidden = NO;
				[_teamAvatarBtn sd_setImageWithURL:[NSURL URLWithString:_team.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"team_addavatar_icon"]];
				
				_location = _team.location;
				if (_team.longitude && _team.latitude) {
					_coordinate = CLLocationCoordinate2DMake(_team.latitudeValue, _team.longitudeValue);
				}
			} else {
				self.title = ZPLocalizedString(@"CREATE A TEAM");
				_team = [BSTeamMO createEntity];
			}
            
            if ([BSUtility getPopUpFirstActionDate:kFirstCreateTeamDate] == nil) {
                [BSUtility savePopUpFirstActionDate:[NSDate date] withKey:kFirstCreateTeamDate];
            }
			
			break;
	}
}

- (void)keyboardDidHide:(NSNotification *)aNotificaiton {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileEditViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateViewControllerWithIdentifier:@"BSProfileEditNavigationViewController"];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_nameTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	
	switch (_dataType) {
		case BSProfileEditDataTypeMeUpdate:
			_sportLabel.text = @(_user.sports.count).stringValue;
			break;
			
		case BSProfileEditDataTypeTeamCreate:
		case BSProfileEditDataTypeTeamUpdate:
			if (_team.sports.count > 0) {
				_sportLabel.text = @(_team.sports.count).stringValue;
				_sportLabel.textColor = [UIColor blackColor];
			} else {
				_sportLabel.text = ZPLocalizedString(@"REQUIRED");
				_sportLabel.textColor = [BSUIGlobal placeholderColor];
			}
			
			if (CLLocationCoordinate2DIsValid(_coordinate) && _location && _location.length > 0) {
				_locationLbl.text = _location;
				_locationLbl.textColor = [UIColor blackColor];
			} else {
				_locationLbl.text = ZPLocalizedString(@"REQUIRED");
				_locationLbl.textColor = [BSUIGlobal placeholderColor];
			}
			break;
	}
}

- (void)drawAvatarDashLine {
    CGSize dashImageSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width);
    UIGraphicsBeginImageContext(dashImageSize);
    [_dashImg.image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGFloat dashArray[] = {2, 3};
    CGContextSetLineDash(context, 0.0, dashArray, 2);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddEllipseInRect(context, aRect);
    CGContextDrawPath(context, kCGPathStroke);
    _dashImg.image = UIGraphicsGetImageFromCurrentImageContext();
}

- (void)updateUIWithUser:(BSUserMO *)user {
    [_avatarImg sd_setImageWithURL:[NSURL URLWithString:user.large_avatar_url] placeholderImage:[UIImage imageNamed:@"common_userdefaultportrait_huge"]];
    [_userIdLbl setText:user.name_id];
    [_emailLbl setText:user.email.uppercaseString];
    [_nameTextField setText:user.name_human_readable];
}

- (IBAction)avatarTapped:(id)sender {
	void (^showImagePicker) (BOOL isCamera) = ^(BOOL isCamera) {
		[BSUIGlobal showImagePickerControllerInViewController:self additionalConstruction:^(UIImagePickerController *picker) {
			picker.sourceType = isCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
		} didFinishPickingMedia:^(NSDictionary *info) {
			UIImage *image = info[UIImagePickerControllerEditedImage];
			if (image) {
				[self.avatarImg setImage:image];
				_avatarPicked = image;
			}
		} didCancel:nil];
    };
	
	[BSUIGlobal showActionSheetTitle:nil isDestructive:NO actionTitle:ZPLocalizedString(@"Choose a Photo") actionHandler:^{
		[BSEventTracker trackTap:@"choose_photo" page:self properties:nil];
		showImagePicker(NO);
	} additionalConstruction:^(BSUIActionSheet *actionSheet) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[actionSheet addButtonWithTitle:ZPLocalizedString(@"Take a Photo") isDestructive:NO handler: ^{
				[BSEventTracker trackTap:@"take_photo" page:self properties:nil];
				showImagePicker(YES);
			}];
		}
	}];
}

- (IBAction)editTapped:(id)sender {
	if (!_nameTextField.text || _nameTextField.text.length < 2) {
		[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"name"}];
		_nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ZPLocalizedString(@"REQUIRED") attributes:@{NSForegroundColorAttributeName: [BSUIGlobal alertColor]}];
		[_nameTextField shakeAnimation];
		[_nameTextField becomeFirstResponder];
		return;
	}
	
	[_nameTextField resignFirstResponder];
	switch (_dataType) {
		case BSProfileEditDataTypeMeUpdate:
		{
			if (!_avatarPicked && !_user.avatar_url) {
				[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"avatar"}];
				[_avatarBtn shakeAnimation];
				return;
			}
			
			BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest requestWithAvatarImage:_avatarPicked];
			request.user_id = _user.identifierValue;
            request.name_human_readable = _nameTextField.text;
			request.privacy_allow_comments = _user.allow_commentsValue;
			request.privacy_public_profile = _user.is_publicValue;
			request.sports = [BSUtility formatSportsId:_user.sports];
			[BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
			[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
                BSUserMO *user = (BSUserMO *)result.dataModel;
				
				[BSEventTracker trackResult:YES eventName:[self pageName] page:self properties:@{@"user_id":user.identifier, @"avatar_updated":_avatarPicked?@"yes":@"no"}];
				
				[[BSDataManager sharedInstance] updateLocalAvatarWithImage:_avatarPicked];
				[[NSNotificationCenter defaultCenter] postNotificationName:kAvatarDidUpdatedNotification object:nil];
				
                [self updateUIWithUser:user];
				[BSUIGlobal hideLoading];
				[self _dismissViewController];
			} failedBlock:^(BSHttpResponseDataModel *result) {
				[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:(result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description}: nil];
			}];
			break;
		}
		case BSProfileEditDataTypeTeamCreate:
		case BSProfileEditDataTypeTeamUpdate:
			if (!_avatarPicked && !_team.avatar_url) {
				[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"avatar"}];
				[_teamAvatarBtn shakeAnimation];
				return;
			}
			
			if (!CLLocationCoordinate2DIsValid(_coordinate) || !_location || _location.length == 0) {
				[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"location"}];
				_locationLbl.textColor = [BSUIGlobal alertColor];
				[_locationLbl shakeAnimation];
				return;
			}
			
			if (_team.sports.count == 0) {
				[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"sports"}];
				_sportLabel.textColor = [BSUIGlobal alertColor];
				[_sportLabel shakeAnimation];
				return;
			}
			
			[BSUIGlobal showLoadingWithMessage:nil];
			if (_dataType == BSProfileEditDataTypeTeamCreate) {
				// create team
				BSTeamCreateHttpRequest *request = [BSTeamCreateHttpRequest request];
				request.name = _nameTextField.text;
				request.location = _location;
				request.latitude = _coordinate.latitude;
				request.longitude = _coordinate.longitude;
				request.avatarImage = _avatarPicked;
				request.sports = [BSUtility formatSportsId:_team.sports];
				
				[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
					[_team deleteEntity];
					BSTeamMO *team = (BSTeamMO *)result.dataModel;
					[BSEventTracker trackResult:YES eventName:[self pageName] page:self properties:@{@"team_id":team.identifier, @"team_name":team.name, @"team_location":team.location}];

					[BSUIGlobal hideLoading];

					[self dismissViewControllerAnimated:YES completion:^{
						UINavigationController *navigationController = [BSUtility getTopmostViewController].navigationController;
						
						if (navigationController) {
							NSMutableArray *array = [NSMutableArray arrayWithArray:navigationController.viewControllers];
							
							BSProfileViewController *pvc = [BSProfileViewController instanceFromStoryboardWithTeam:team];
							[array addObject:pvc];
							
							BSTeamSettingsViewController *vc = [BSTeamSettingsViewController instanceFromStoryboard];
							vc.team = team;
							[array addObject:vc];
							
							BSTeamInvitationViewController *ivc = [BSTeamInvitationViewController instanceFromStoryboard];
							ivc.team = team;
							[array addObject:ivc];
							
							[navigationController setViewControllers:array animated:YES];
						}
					}];
					
					[[NSNotificationCenter defaultCenter] postNotificationName:kTeamDidAddedNotification object:result.dataModel];
				} failedBlock:^(BSHttpResponseDataModel *result) {
					[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:(result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description}: nil];
				}];
			} else {
				// update team
				BSTeamUpdateHttpRequest *request = [BSTeamUpdateHttpRequest request];
				request.teamId = _team.identifierValue;
				request.avatarImage = _avatarPicked;
				request.sports = [BSUtility formatSportsId:_team.sports];
				
				if (!_team.location || _coordinate.latitude != _team.latitudeValue || _coordinate.longitude != _team.longitudeValue) {
					request.location = _location;
					request.latitude = [NSNumber numberWithFloat:_coordinate.latitude];
					request.longitude = [NSNumber numberWithFloat:_coordinate.longitude];
				}
				
				[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
					[BSEventTracker trackResult:YES eventName:[self pageName] page:self properties:@{@"team_id":_team.identifier, @"team_name":_team.name, @"team_location":_team.location, @"avatar_updated":_avatarPicked?@"yes":@"no"}];

					[BSUIGlobal hideLoading];
					[self _dismissViewController];
				} failedBlock:^(BSHttpResponseDataModel *result) {
					[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:(result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description}: nil];
				}];
			}
			break;
	}
}

- (IBAction)btnClosedTapped:(id)sender {
	switch (_dataType) {
		case BSProfileEditDataTypeMeUpdate:
			_user.sports = _sportsBackup;
			break;
		case BSProfileEditDataTypeTeamCreate:
			[_team deleteEntity];
			break;
		case BSProfileEditDataTypeTeamUpdate:
			_team.sports = _sportsBackup;
			break;
	}
	
    if ([_nameTextField becomeFirstResponder]) {
        [_nameTextField resignFirstResponder];
    }
    [self _dismissViewController];
}

- (IBAction)btnTeamAvatarTapped:(id)sender {
	UINavigationController *nvc = [[UIStoryboard storyboardWithName:@"Team" bundle:nil] instantiateViewControllerWithIdentifier:@"BSTeamAvatarEditNavigationViewController"];
	BSTeamAvatarEditViewController *vc = (BSTeamAvatarEditViewController *)nvc.topViewController;
	vc.team = _team;
	vc.modifiedAvatar = _avatarPicked;
	vc.delegate = self;
	
	[self presentViewController:nvc animated:YES completion:nil];
}

- (void)_dismissViewController {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - BSTeamAvatarEditDelegate
- (void) didEditAvatar:(UIImage *)image {
	_avatarPicked = image;
	[_teamAvatarBtn setImage:image forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return _dataType == BSProfileEditDataTypeMeUpdate ? 1 : 2;
	} else {
		return 6;
	}
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return _dataType == BSProfileEditDataTypeMeUpdate ? self.view.width : 0;
		} else {
			return _dataType == BSProfileEditDataTypeMeUpdate ? 0 : 213;
		}
	} else {
		if (_dataType == BSProfileEditDataTypeMeUpdate) {
			switch (indexPath.row) {
				case 0:
				case 1:
				case 2:
				case 3:
				case 5:
					return 65.0;
					
				default:
					return 0.0;
			}
		} else {
			switch (indexPath.row) {
				case 0:
				case 4:
				case 5:
					return 65.0;
					
				default:
					return 0.0;
			}
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					[self avatarTapped:nil];
					break;
				case 1:
					[self btnTeamAvatarTapped:nil];
					break;
				default:
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 4:
					// team location
					break;
				case 5:
				{
					[BSEventTracker trackTap:@"add_sports" page:self properties:nil];
					BSAddSportsViewController *vc;
					if (_dataType == BSProfileEditDataTypeMeUpdate) {
						vc = [BSAddSportsViewController instanceFromStoryboardWithUser:_user];
						vc.title = ZPLocalizedString(@"Favourite Sports").uppercaseString;
					} else {
						vc = [BSAddSportsViewController instanceFromStoryboardWithTeam:_team];
						vc.title = ZPLocalizedString(@"Sports").uppercaseString;
					}
					vc.autoSyncWithServer = NO;
					[self.navigationController pushViewController:vc animated:YES];
				}
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

#pragma mark -  BSLocationViewControllerDelegate
- (void) didSelectMapAnnotation:(BSMapAnnotation *)mapAnnotation {
	_coordinate = mapAnnotation.coordinate;
	_location = mapAnnotation.title;
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"BSTeamLocationSegue"]) {
		BSTeamLocationViewController *vc = (BSTeamLocationViewController *)segue.destinationViewController;
		if (_location && CLLocationCoordinate2DIsValid(_coordinate)) {
			vc.mapAnnotation = [[BSMapAnnotation alloc] initWithCoordinate:_coordinate];
			vc.mapAnnotation.title = _location;
		}
		vc.delegate = self;
	}
}

#pragma mark - name text field change
- (void)handleTextChange:(NSNotification *)notification {
	if (_nameTextField.text.length > 30) {
		_nameTextField.text = [_nameTextField.text substringToIndex:30];
		[BSUIGlobal showMessage:ZPLocalizedString(@"Name needs to be 2 - 30 characters long")];
	}
}

#pragma mark - UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - event tracking
- (NSString *) pageName {
	switch (_dataType) {
		case BSProfileEditDataTypeMeUpdate:
			return @"edit_profile";
		case BSProfileEditDataTypeTeamCreate:
			return @"create_team";
		case BSProfileEditDataTypeTeamUpdate:
			return @"edit_team";
		default:
			return nil;
	}
}

@end
