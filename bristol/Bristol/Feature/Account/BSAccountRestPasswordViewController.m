//
//  BSAccountRestPasswordViewController.m
//  Bristol
//
//  Created by Bo on 4/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountRestPasswordViewController.h"

#import "BSCheckEmailHttpRequest.h"
#import "BSForgetPasswordHttpRequest.h"

#import "BSUsersDataModel.h"

#import "BSUIGlobal.h"

@interface BSAccountRestPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@end

@implementation BSAccountRestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)resetBtnTapped:(id)sender {
    [self resetPassword];
}

- (void)resetPassword {
    [self tapToHideKeyboard];
    
    NSString *strEmail = [_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![strEmail isValidEmail]) {
        [BSUIGlobal showMessage:ZPLocalizedString(@"Invalid email address.")];
        _txtEmail.textColor = [UIColor redColor];
        [_txtEmail shakeAnimation];
        return;
    }
	
	[BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
	
    BSCheckEmailHttpRequest *request = [BSCheckEmailHttpRequest request];
    request.email = _txtEmail.text;
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        BSCheckUserEmailModel *dataModel = (BSCheckUserEmailModel *)result.dataModel;
        if (!dataModel.user_exists && !dataModel.bristol_logged_in && !dataModel.zepp_facebook_user) {
            [BSUIGlobal showMessage:ZPLocalizedString(@"Email address not registered.")];
            _txtEmail.textColor = [UIColor redColor];
		} else {
			BSForgetPasswordHttpRequest *forgetPasswordHttpRequest = [BSForgetPasswordHttpRequest request];
			forgetPasswordHttpRequest.email = _txtEmail.text;
			[forgetPasswordHttpRequest postRequestWithSucceedBlock:^(ZPHttpResponseDataModel *result) {
				[BSUIGlobal showMessage:ZPLocalizedString(@"Email has been sent.")];
			} failedBlock:nil];
		}
    } failedBlock:nil];

}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    [self tapToHideKeyboard];
}

- (void)tapToHideKeyboard {
    [_txtEmail resignFirstResponder];
}

- (void)textFieldDidChange {
    if (_txtEmail.text.length == 0) {
        _lblEmail.hidden = NO;
    } else {
        _lblEmail.hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtEmail) {
        [self resetPassword];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.textColor = [UIColor blackColor];
    
    return YES;
}

@end
