//
//  BSAccountPersonalizeProfileViewController.m
//  Bristol
//
//  Created by Bo on 3/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountPersonalizeProfileViewController.h"
#import "BSAccountFollowStarViewController.h"
#import "BSAvatarButton.h"

#import "BSSignUpWithEmailHttpRequest.h"
#import "BSMeSetUsernameHttpRequest.h"
#import "BSMeCompleteUserInfoHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSMeUpdateProfileHttpRequest.h"

#import "UIButton+WebCache.h"
#import "BSEventTracker.h"

@interface BSAccountPersonalizeProfileViewController ()<UITextFieldDelegate>
{
    UIImage *_avatarPicked;
    NSArray *_followers;
}
@property (nonatomic, strong) BSUserMO *user;
@property (nonatomic, strong) NSString *email;

@property (weak, nonatomic) IBOutlet UITextField *txtPasswordOrEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtID;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordOrEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLock;
@property (weak, nonatomic) IBOutlet UIView *avatarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblPwdPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblNamePlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblUsernamePlaceholder;

@end

@implementation BSAccountPersonalizeProfileViewController

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountPersonalizeProfileViewController"];
}

+ (instancetype)instanceFromStoryboardWithUser:(BSUserMO *)user {
    NSParameterAssert([user isKindOfClass:[BSUserMO class]]);
    
    BSAccountPersonalizeProfileViewController *vc = [BSAccountPersonalizeProfileViewController instanceFromStoryboard];
    vc.user = user;
    return vc;
}

+ (instancetype)instanceFromStoryboardWithEmail:(NSString *)email {
    NSParameterAssert([email isKindOfClass:[NSString class]]);
    
    BSAccountPersonalizeProfileViewController *vc = [BSAccountPersonalizeProfileViewController instanceFromStoryboard];
    vc.email = email;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtName.text = _user.name_human_readable;
    _txtID.text = _user.name_id;
    if (_email) {
        _lblPasswordOrEmail.text = ZPLocalizedString(@"Password");
        _txtPasswordOrEmail.text = nil;
        _txtPasswordOrEmail.secureTextEntry = YES;
    } else {
        _lblPasswordOrEmail.text = ZPLocalizedString(@"Email");
        _txtPasswordOrEmail.text = _user.email;
        _txtPasswordOrEmail.secureTextEntry = NO;
		if (_user.email) {
			[_pwdView removeFromSuperview];
			_nameViewTopConstraint = nil;
			[_imgAvatar autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_nameView withOffset:10];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (IBAction)btnContinueTapped:(id)sender {
    [self continueWithUserInfo];
}

- (IBAction)imgAvatarTapped:(id)sender {
	[BSEventTracker trackTap:@"edit_photo" page:self properties:nil];
    void (^showImagePicker) (BOOL isCamera) = ^(BOOL isCamera) {
		[BSUIGlobal showImagePickerControllerInViewController:self additionalConstruction:^(UIImagePickerController *picker) {
			picker.sourceType = isCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
		} didFinishPickingMedia:^(NSDictionary *info) {
			UIImage *image = info[UIImagePickerControllerEditedImage];
			if (image) {
				[_imgAvatar setImage:image];
				_avatarPicked = image;
			}
		} didCancel:nil];
    };
	
	[BSUIGlobal showActionSheetTitle:nil isDestructive:YES actionTitle:ZPLocalizedString(@"Choose a Photo") actionHandler:^{
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

- (void)continueWithUserInfo {
    [self hideKeyboard];
    
    NSString *strPasswordOrEmail = [_txtPasswordOrEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strID = [_txtID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strName = [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (_email) {
        if (![strPasswordOrEmail isValidPassword]) {
			[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"password"}];
            [BSUIGlobal showMessage:ZPLocalizedString(@"The passwords you typed don't match.")];
            _txtPasswordOrEmail.textColor = [UIColor redColor];
            [_txtPasswordOrEmail shakeAnimation];
            return;
        }
    } else {
        if (!_user.email && ![strPasswordOrEmail isValidEmail]) {
			[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"email"}];
            [BSUIGlobal showMessage:ZPLocalizedString(@"Invalid email address.")];
            _txtPasswordOrEmail.textColor = [UIColor redColor];
            [_txtPasswordOrEmail shakeAnimation];
            return;
        }
    }
    
    if (![strName isValidUserName]) {
		[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"name"}];
        [BSUIGlobal showMessage:ZPLocalizedString(@"Name needs to be 2 - 30 characters long")];
        _txtName.textColor = [UIColor redColor];
        [_txtName shakeAnimation];
        return;
    }
    
    if (![strID isValidUserID]) {
		[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:@{@"reason":@"username"}];
        if (strID.length < 5 || strID.length > 30) {
            [BSUIGlobal showMessage:ZPLocalizedString(@"Username needs to be 5 - 30 characters long.")];
        } else {
            [BSUIGlobal showMessage:ZPLocalizedString(@"Correct Username Description")];
        }
        _txtID.textColor = [UIColor redColor];
        [_txtID shakeAnimation];
        return;
    }
    
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    
    if (_email) {
        BSSignUpWithEmailHttpRequest *request = [BSSignUpWithEmailHttpRequest request];
        request.email = _email;
        request.password = strPasswordOrEmail;
        request.name_id = strID;
        request.name_human_readable = strName;
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
            [BSUIGlobal hideLoading];
			
            BSSignUpDataModel *dataModel = (BSSignUpDataModel *)result.dataModel;
            _followers = dataModel.followed_users;
            _user = dataModel.user;
            _user.name_human_readable = strName;
            [[BSDataManager sharedInstance] setCurrentUserWithId:_user.identifier];
            
            [self _checkIfNeedToUpdateAvatarWithDataModel:dataModel];
        } failedBlock:^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:((result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description} : nil)];
		}];
    } else {
        BSMeCompleteUserInfoHttpRequest *request = [BSMeCompleteUserInfoHttpRequest request];
        request.user_id = _user.identifierValue;
        request.email = _email;
        request.name_id = strID;
        request.name_human_readable = strName;
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
            [BSUIGlobal hideLoading];

            BSSetUserNameDataModel *dataModel = (BSSetUserNameDataModel *)result.dataModel;
            _followers = dataModel.followed_users;
            [[BSDataManager sharedInstance] setCurrentUserWithId:_user.identifier];
            
            [self _checkIfNeedToUpdateAvatarWithDataModel:dataModel];
		} failedBlock:^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:((result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description} : nil)];
		}];
    }
}

- (void)_gotoFollowerStartView {
	[BSEventTracker trackResult:YES eventName:@"continue" page:self properties:nil];

    BSAccountFollowStarViewController *vc = [BSAccountFollowStarViewController instanceFromStoryboard];
    vc.followedUsers = _followers;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_checkIfNeedToUpdateAvatarWithDataModel:(BSUsersDataModel *)dataModel {
    if (_avatarPicked) {
        [BSUIGlobal showLoadingWithMessage:@"Waiting"];
        
        BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest requestWithAvatarImage:_avatarPicked];
        request.user_id = _user.identifierValue;
        request.name_human_readable = _user.name_human_readable;
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
            [BSUIGlobal hideLoading];
            
            [[BSDataManager sharedInstance] updateLocalAvatarWithImage:_avatarPicked];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAvatarDidUpdatedNotification object:nil];
            
            [self _gotoFollowerStartView];
		} failedBlock:^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:NO eventName:@"display_error" page:self properties:((result.error.description && result.error.description.length > 0) ? @{@"reason":result.error.description} : nil)];
		}];
    } else {
        [self _gotoFollowerStartView];
    }
}

- (void)hideKeyboard {
    [_txtPasswordOrEmail resignFirstResponder];
    [_txtName resignFirstResponder];
    [_txtID resignFirstResponder];
}

- (IBAction)tapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField notification
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.textColor = [UIColor blackColor];
    
    return YES;
}


- (void)textFieldDidChange{
    if (_txtPasswordOrEmail.text.length > 0) {
        _lblPwdPlaceholder.hidden = YES;
    } else {
        _lblPwdPlaceholder.hidden = NO;
    }
    
    if (_txtName.text.length > 0) {
        _lblNamePlaceholder.hidden = YES;
    } else {
        _lblNamePlaceholder.hidden = NO;
    }
    
    if (_txtID.text.length > 0) {
        _lblUsernamePlaceholder.hidden = YES;
    } else {
        _lblUsernamePlaceholder.hidden = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtPasswordOrEmail) {
        [_txtName becomeFirstResponder];
    }
    if (textField == _txtName) {
        [_txtID becomeFirstResponder];
    }
    if (textField == _txtID) {
        [self continueWithUserInfo];
    }
    
    return YES;
}

#pragma mark - event tracking
- (NSString *) useCase {
	if (_email) {
		return @"enter_password";
	} else {
		return @"enter_email";
	}
}
@end
