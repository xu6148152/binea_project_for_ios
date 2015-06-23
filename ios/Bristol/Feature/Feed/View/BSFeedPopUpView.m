//
//  BSFeedPromptView.m
//  Bristol
//
//  Created by Bo on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedPopUpView.h"

@implementation BSFeedPopUpView
- (id)init {
    self = [super init];
    if (self) {
        [self _commitInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _commitInit];
}

- (void)_commitInit {
    _lblMessage.delegate = self;
}

- (void)configWithTitle:(NSString *)title content:(NSString *)content attributeContent:(NSString *)attributeContent btnImgName:(NSString *)btnImgName isDownArrowImgHidden:(BOOL)isHidden {
    [_lblName setText:title];
    [self configAttributeLabelWithContent:content attributeContent:attributeContent];
    [_btnAdd setImage:[UIImage imageNamed:btnImgName] forState:UIControlStateNormal];
    _downArrowImgView.hidden = isHidden;
}

- (void)configAttributeLabelWithContent:(NSString *)content attributeContent:(NSString *)attributeContent {
    UIFont *baseFont = [UIFont fontWithName:@"Avenir-LightOblique" size:14];
    CTFontRef baseFontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
    _lblMessage.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName : [UIColor colorWithRed:200/255.0f green:235/255.0f blue:0 alpha:1], (NSString *)kCTUnderlineStyleAttributeName : @(NO), (NSString *)kCTFontAttributeName : (__bridge id)baseFontRef };
    CFRelease(baseFontRef);
    _lblMessage.activeLinkAttributes = _lblMessage.linkAttributes;
    _lblMessage.inactiveLinkAttributes = _lblMessage.linkAttributes;
    
    NSString *contentText = [NSString stringWithFormat:@"%@ %@", content, attributeContent];
    NSMutableArray *textCheckingResults = [NSMutableArray array];
    [_lblMessage setText:contentText afterInheritingLabelAttributesAndConfiguringWithBlock: ^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     {
         NSRange currentRange = [[mutableAttributedString string] rangeOfString:attributeContent options:NSCaseInsensitiveSearch];
         NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:currentRange URL:nil];
         [textCheckingResults addObject:result];
         return mutableAttributedString;
     }];
    
    for (NSTextCheckingResult *result in textCheckingResults) {
        [_lblMessage addLinkWithTextCheckingResult:result];
    }
}

- (IBAction)tapFeedUpViewAddButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(feedPopUpViewDidTapAddButton)]) {
        [_delegate feedPopUpViewDidTapAddButton];
    }
}

- (IBAction)tapFeedUpViewCloseButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(feedPopUpViewDidTapCloseButton)]) {
        [_delegate feedPopUpViewDidTapCloseButton];
    }
}

#pragma mark TTTAttributeLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    if ([_delegate respondsToSelector:@selector(feedPopUpViewDidTapAttributeLabel)]) {
        [_delegate feedPopUpViewDidTapAttributeLabel];
    }
}

@end
