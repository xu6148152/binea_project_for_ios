//
//  BSAccountLoginViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/28/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountLoginViewController.h"
#import "BSSignInWithEmailHttpRequest.h"
#import "BSMainViewController.h"
#import "BSAccountPersonalizeProfileViewController.h"
#import "BSAccountCreateProfileViewController.h"

#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"

#import "BSUserMO.h"
#import "BSSignInWithFacebookHttpRequest.h"
#import "BSSignInWithTwitterHttpRequest.h"
#import "BSSignInWithInstagramHttpRequest.h"

#import "BSEventTracker.h"

@interface BSAccountLoginViewController () <UITextFieldDelegate>
{
    BOOL _isLoginWithZeppAccount;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIView *otherLoginView;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblPwdPlaceholder;

@end

@implementation BSAccountLoginViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountLoginViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountLoginViewControllerNav"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    if (_createProfileWithZeppUser) {
        [_lblEmail setText:ZPLocalizedString(@"Zepp Account")];
        [_lblHeader setText:ZPLocalizedString(@"Welcome")];
        [_txtEmail setText:_zeppAccount];
        _txtEmail.enabled = NO;
        [_lblPwdPlaceholder setText:ZPLocalizedString(@"Zepp account password")];
        _otherLoginView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (_createProfileWithZeppUser) {
        [BSUIGlobal showMessage:ZPLocalizedString(@"Zepp users can log in with their existing Zepp account.")];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

   [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)btnZeppTapped:(id)sender {
    _isLoginWithZeppAccount = YES;
    [_lblEmail setText:ZPLocalizedString(@"Zepp Account")];
}

- (IBAction)btnLoginTapped:(UIButton *)sender {
    [self loginWithEmailAndPwd];
}

- (void)loginWithEmailAndPwd {
    [self _hideKeyboard];
    
    NSString *strEmail = _txtEmail.text;
    NSString *strPassword = _txtPassword.text;
    
    if (!_createProfileWithZeppUser && ![strEmail isValidEmail]) {
        _txtEmail.textColor = [UIColor redColor];
        [_txtEmail shakeAnimation];
        [BSUIGlobal showMessage:ZPLocalizedString(@"Invalid email address.")];
        return;
    }
    
    if (![strPassword isValidPassword]) {
        [_txtPassword shakeAnimation];
        [BSUIGlobal showMessage:ZPLocalizedString(@"The passwords you typed don't match.")];
        return;
    }
    
    _btnLogin.enabled = NO;
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    
    BSSignInWithEmailHttpRequest *loginRequest = [BSSignInWithEmailHttpRequest requestWithEmail:strEmail password:strPassword];
    [loginRequest postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
        [BSUIGlobal showMessage:result.message];
        
        BSUserMO *user = result.dataModel;
        user.email = strEmail;// NOTE: not response email yet, so update with local's.
        
        if (user.name_id) {
            [[BSDataManager sharedInstance] setCurrentUserWithId:user.identifier];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            _btnLogin.enabled = YES;
        } else {
            [self.navigationController pushViewController:[BSAccountPersonalizeProfileViewController instanceFromStoryboardWithUser:user] animated:YES];
            _btnLogin.enabled = YES;
        }
		
		[BSEventTracker trackResult:YES eventName:@"email_login" page:self properties:nil];
    } failedBlock: ^(BSHttpResponseDataModel *result) {
        _btnLogin.enabled = YES;
    }];
}

- (void)_hideKeyboard {
	[_txtEmail resignFirstResponder];
	[_txtPassword resignFirstResponder];
}

- (IBAction)tapToHideKeyboard:(id)sender {
    [self _hideKeyboard];
}

- (IBAction)tapBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btnFacebookTapped:(id)sender {
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    [ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
		BSSignInWithFacebookHttpRequest *request = [[BSSignInWithFacebookHttpRequest alloc] init];
		request.accessToken = accessToken;
		[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			[BSEventTracker trackResult:YES eventName:@"facebook_login" page:self properties:nil];
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
			[BSEventTracker trackResult:YES eventName:@"twitter_login" page:self properties:nil];
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
			[BSEventTracker trackResult:YES eventName:@"instagram_login" page:self properties:nil];
			[self _connectWithSocialNetworkSuccess:result];
		} failedBlock:nil];
	} faildHandler:^(NSError *error) {
		[BSUIGlobal showError:error];
	}];
}

- (void)textFieldDidChange {
    if (_txtEmail.text.length > 0) {
        _lblEmailPlaceholder.hidden = YES;
    } else {
        _lblEmailPlaceholder.hidden = NO;
    }
    
    if (_txtPassword.text.length > 0) {
        _lblPwdPlaceholder.hidden = YES;
    } else {
        _lblPwdPlaceholder.hidden = NO;
    }
}

#pragma mark TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.textColor = [UIColor blackColor];
    
    if (textField == _txtEmail || textField == _txtPassword) {
        NSRange whitespaceRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        return whitespaceRange.location == NSNotFound;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtEmail) {
        [_txtPassword becomeFirstResponder];
    } else {
        [self loginWithEmailAndPwd];
    }
    return YES;
}

@end
