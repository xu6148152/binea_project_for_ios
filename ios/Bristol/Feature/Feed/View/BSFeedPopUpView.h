//
//  BSFeedPromptView.h
//  Bristol
//
//  Created by Bo on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAttributedLabel.h"

@protocol BSFeedPopUpViewDelegate <NSObject>

@optional

- (void)feedPopUpViewDidTapAddButton;
- (void)feedPopUpViewDidTapAttributeLabel;
- (void)feedPopUpViewDidTapCloseButton;

@end

@interface BSFeedPopUpView : UIView <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImgView;

@property (weak, nonatomic) id <BSFeedPopUpViewDelegate> delegate;

- (void)configWithTitle:(NSString *)title content:(NSString *)content attributeContent:(NSString *)attributeContent btnImgName:(NSString *)btnImgName isDownArrowImgHidden:(BOOL)isHidden;

@end
