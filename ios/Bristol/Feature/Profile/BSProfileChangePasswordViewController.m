//
//  BSProfileChangePasswordViewController.m
//  Bristol
//
//  Created by Bo on 2/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileChangePasswordViewController.h"
#import "BSDataManager.h"
#import "FXKeychain.h"

#import "BSMeChangePasswordHttpRequest.h"
#import "BSUserMO.h"

@interface BSProfileChangePasswordViewController ()
{
    BSUserMO *_currentUser;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrentPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPwd;

@end

@implementation BSProfileChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZPLocalizedString(@"CHANGE PASSWORD").uppercaseString;
	[self.tableView setGlobalUI];
    [self.tableView setClearEmptyFooterSeperator:YES];
    
    _currentUser = [BSDataManager sharedInstance].currentUser;
}

#pragma mark - UITabelView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (IBAction)tapDismiss:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)tapChangePassword:(id)sender {
    [self hideKeyboard];
    
    NSString *strCurrentPwd = _textFieldCurrentPwd.text;
    NSString *strNewPwd = _textFieldNewPwd.text;
    NSString *strConfirmPwd = _textFieldConfirmPwd.text;
    
    if (strCurrentPwd.length < 6) {
        [_textFieldCurrentPwd shakeAnimation];
        [BSUIGlobal showMessage:ZPLocalizedString(@"Your password is too short. Please choose a password with at least 6 characters.")];
        return;
    }
    if (strNewPwd.length < 6) {
        [_textFieldNewPwd shakeAnimation];
         [BSUIGlobal showMessage:ZPLocalizedString(@"Your password is too short. Please choose a password with at least 6 characters.")];
        return;
    }
    if (strConfirmPwd.length < 6) {
        [_textFieldConfirmPwd shakeAnimation];
         [BSUIGlobal showMessage:ZPLocalizedString(@"Your password is too short. Please choose a password with at least 6 characters.")];
        return;
    }
    
    if (![strNewPwd isEqualToString:strConfirmPwd]) {
        [BSUIGlobal showMessage:ZPLocalizedString(@"The passwords you typed don't match.")];
        return;
    }
    
    [BSUIGlobal showLoadingWithMessage:ZPLocalizedString(@"Waiting")];
    
    BSMeChangePasswordHttpRequest *request = [BSMeChangePasswordHttpRequest request];
    request.user_id = _currentUser.identifierValue;
    request.oldPassword = strCurrentPwd;
    request.currentPassword = strNewPwd;
    [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
        [BSUIGlobal hideLoading];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failedBlock:nil];
}



- (void)hideKeyboard {
    [_textFieldCurrentPwd resignFirstResponder];
    [_textFieldNewPwd resignFirstResponder];
    [_textFieldConfirmPwd resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _textFieldCurrentPwd || textField == _textFieldNewPwd || textField == _textFieldConfirmPwd) {
        NSRange whitespaceRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        return whitespaceRange.location == NSNotFound;
    }
    else
        return YES;
}

@end
