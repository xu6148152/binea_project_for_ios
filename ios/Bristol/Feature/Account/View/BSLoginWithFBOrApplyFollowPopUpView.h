//
//  BSLoginWithFBOrApplyFollowPopUpView.h
//  Bristol
//
//  Created by Bo on 4/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BSLoginWithFBOrApplyFollowPopUpView <NSObject>

@optional

- (void)BSLoginWithFBPopUpViewDidTapLoginButton;
- (void)BSLoginWithFBPopUpViewDidTapCancelButton;

@end

@interface BSLoginWithFBOrApplyFollowPopUpView : UIView

@property (weak, nonatomic) id <BSLoginWithFBOrApplyFollowPopUpView> delegate;

- (void)configWithPrompt:(NSString *)text btnTitle:(NSString *)title btnColor:(UIColor *)color;

@end
