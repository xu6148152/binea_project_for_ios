//
//  BSAccountCreateProfileViewController.m
//  Bristol
//
//  Created by Bo on 3/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountCreateProfileViewController.h"
#import "BSAccountPersonalizeProfileViewController.h"
#import "BSCheckEmailHttpRequest.h"
#import "BSUsersDataModel.h"
#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"
#import "BSAccountLoginViewController.h"
#import "BSLoginWithFBOrApplyFollowPopUpView.h"
#import "BSAccountTermsOfServiceViewController.h"

#import "BSSignInWithFacebookHttpRequest.h"
#import "BSSignInWithTwitterHttpRequest.h"
#import "BSSignInWithInstagramHttpRequest.h"

@interface BSAccountCreateProfileViewController ()<UITextFieldDelegate, BSLoginWithFBOrApplyFollowPopUpView>
{
    BSLoginWithFBOrApplyFollowPopUpView *_popUpView;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@end

@implementation BSAccountCreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

   [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)btnSignUpTapped:(id)sender {
    [self signUpWithEmail];
}

- (void)hideKeyboard {
    [_txtEmail resignFirstResponder];
}

- (IBAction)tapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTermsOfServiceTapped:(id)sender {
    BSAccountTermsOfServiceViewController *vc = [BSAccountTermsOfServiceViewController instanceFromStoryboard];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)signUpWithEmail {
    [self hideKeyboard];
    
    NSString *strEmail = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![strEmail isValidEmail]) {
        _txtEmail.textColor = [UIColor redColor];
        [_txtEmail shakeAnimation];
        [BSUIGlobal showMessage:ZPLocalizedString(@"Invalid email address.")];
        return;
    }
    
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    BSCheckEmailHttpRequest *request = [BSCheckEmailHttpRequest request];
    request.email = strEmail;
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        BSCheckUserEmailModel *dataModel = (BSCheckUserEmailModel *)result.dataModel;
        if (dataModel.bristol_logged_in) {
            [BSUIGlobal showMessage:ZPLocalizedString(@"Email has been taken.")];
		} else {
			[BSUIGlobal hideLoading];
			
            if (dataModel.user_exists && !dataModel.zepp_facebook_user) {
                BSAccountLoginViewController *vc = [BSAccountLoginViewController instanceFromStoryboard];
                vc.createProfileWithZeppUser = YES;
                vc.zeppAccount = strEmail;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (!dataModel.user_exists && !dataModel.zepp_facebook_user) {
				[BSEventTracker trackResult:YES eventName:@"email_signup" page:self properties:nil];
                [self.navigationController pushViewController:[BSAccountPersonalizeProfileViewController instanceFromStoryboardWithEmail:strEmail] animated:YES];
            }
            if (dataModel.user_exists && dataModel.zepp_facebook_user) {
                NSArray *viewAry = [[NSBundle mainBundle] loadNibNamed:BSLoginWithFBOrApplyFollowPopUpView.className owner:self options:nil];
                _popUpView = [viewAry firstObject];
                _popUpView.delegate = self;
                _popUpView.frame = CGRectMake(0, DeviceMainScreenSize.height, DeviceMainScreenSize.width, 226);
                [_popUpView configWithPrompt:ZPLocalizedString(@"Zepp users can log in directly via Facebook, or create an account with another email address.") btnTitle:ZPLocalizedString(@"LOG IN VIA FACEBOOK") btnColor:[UIColor colorWithRed255:46.0F green255:46.0f blue255:46.0f alphaFloat:1.0f]];
                [self.view addSubview:_popUpView];
                [UIView animateWithDuration:kDefaultAnimateDuration animations:^{
                    _popUpView.frame = CGRectMake(0, DeviceMainScreenSize.height - 226, DeviceMainScreenSize.width, 226);
                }];
            }
        }
    } failedBlock:nil];
}

- (IBAction)btnFacebookTapped:(id)sender {
    [self loginWithFacebook];
}

- (void)textFieldDidChange {
    if (_txtEmail.text.length == 0) {
        _lblEmail.hidden = NO;
    } else {
        _lblEmail.hidden = YES;
    }
}

- (void)_connectWithSocialNetworkSuccess:(BSHttpResponseDataModel *)responseDataModel {
    [BSUIGlobal hideLoading];
    
    BSUserMO *user = responseDataModel.dataModel;
	if (user.name_id) {
		[[BSDataManager sharedInstance] setCurrentUserWithId:user.identifier];
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }else {
        [self.navigationController pushViewController:[BSAccountPersonalizeProfileViewController instanceFromStoryboardWithUser:user] animated:YES];
    }
}

- (void)loginWithFacebook {
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    [ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
        BSSignInWithFacebookHttpRequest *request = [[BSSignInWithFacebookHttpRequest alloc] init];
        request.accessToken = accessToken;
        [request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:YES eventName:@"facebook_signup" page:self properties:nil];
            [self _connectWithSocialNetworkSuccess:result];
		} failedBlock:nil];
    } faildHandler:^(NSError *error) {
		[BSUIGlobal showError:error];
	}];
}

- (IBAction)btnTwitterTapped:(id)sender {
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    [ZPTwitterSharer connectWithSuccessHandler:^(NSString *authToken, NSString *authTokenSecret) {
        BSSignInWithTwitterHttpRequest *request = [BSSignInWithTwitterHttpRequest request];
        request.accessToken = authToken;
        request.accessSecret = authTokenSecret;
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:YES eventName:@"twitter_signup" page:self properties:nil];
            [self _connectWithSocialNetworkSuccess:result];
		} failedBlock:nil];
    } faildHandler:^(NSError *error) {
		[BSUIGlobal showError:error];
	}];
}

- (IBAction)btnInstagramTapped:(id)sender {
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    [ZPInstagramSharer connectWithShowInViewController:self successHandler:^(NSString *code) {
        BSSignInWithInstagramHttpRequest *request = [BSSignInWithInstagramHttpRequest request];
        request.code = code;
        [request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:YES eventName:@"instagram_signup" page:self properties:nil];
            [self _connectWithSocialNetworkSuccess:result];
        } failedBlock:nil];
    } faildHandler:^(NSError *error) {
        [BSUIGlobal showError:error];
    }];
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self signUpWithEmail];
    return YES;
}

- (IBAction)tapToHideTextField:(id)sender {
    [self hideKeyboard];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - BSLoginWithFBOrApplyFollowPopUpView
- (void)BSLoginWithFBPopUpViewDidTapLoginButton {
    [self loginWithFacebook];
}

- (void)BSLoginWithFBPopUpViewDidTapCancelButton {
    [UIView animateWithDuration:kDefaultAnimateDuration animations:^{
        _popUpView.frame = CGRectMake(0, DeviceMainScreenSize.height, _popUpView.bounds.size.width, _popUpView.bounds.size.height);
    } completion:^(BOOL finished) {
        _popUpView = nil;
    }];
}

@end
