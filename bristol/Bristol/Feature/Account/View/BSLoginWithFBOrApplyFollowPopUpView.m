//
//  BSLoginWithFBOrApplyFollowPopUpView.m
//  Bristol
//
//  Created by Bo on 4/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLoginWithFBOrApplyFollowPopUpView.h"
#import "BSAttributedLabel.h"

@interface BSLoginWithFBOrApplyFollowPopUpView ()

@property (weak, nonatomic) IBOutlet BSAttributedLabel *txtPrompt;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;

@end

@implementation BSLoginWithFBOrApplyFollowPopUpView

- (IBAction)btnLoginViaFacebookTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(BSLoginWithFBPopUpViewDidTapLoginButton)]) {
        [_delegate BSLoginWithFBPopUpViewDidTapLoginButton];
    }
}

- (IBAction)btnCancelTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(BSLoginWithFBPopUpViewDidTapCancelButton)]) {
        [_delegate BSLoginWithFBPopUpViewDidTapCancelButton];
    }
}

- (void)configWithPrompt:(NSString *)text btnTitle:(NSString *)title btnColor:(UIColor *)color {
    [_txtPrompt setText:text];
    [_btnAction setTitle:title forState:UIControlStateNormal];
    [_btnAction setBackgroundColor:color];
}

@end
