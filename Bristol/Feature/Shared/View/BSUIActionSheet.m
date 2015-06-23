//
//  BSUIActionSheet.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUIActionSheet.h"
#import "PureLayout.h"

#define kHandler @"kHandler"

@interface BSUIActionSheet()
{
	NSMutableArray *_buttonsMapping;
	NSArray *_buttonsInDesign;
	CGFloat _currentRGBValue;
}
@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end



@implementation BSUIActionSheet

+ (id)actionSheetWithTitle:(NSString *)title {
	BSUIActionSheet *sheet = [[[UINib nibWithNibName:@"BSUIActionSheet" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
	sheet.lblTitle.text = title;
	sheet.titleView.hidden = title.length == 0;
	return sheet;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	_buttonsMapping = [NSMutableArray array];
	_buttonsInDesign = @[_btn0, _btn1, _btn2, _btn3, _btn4];
	_currentRGBValue = 70;
}

- (void)dealloc {
	
}

- (NSLayoutConstraint *)_getHeightConstraintForButton:(UIButton *)btn {
	for (NSLayoutConstraint *constraint in btn.constraints) {
		if (constraint.firstAttribute == NSLayoutAttributeHeight) {
			return constraint;
		}
	}
	return nil;
}

- (NSInteger)addButtonWithTitle:(NSString *)title isDestructive:(BOOL)isDestructive handler:(ZPVoidBlock)handler {
	[_buttonsMapping addObject:@{kHandler:handler ? [handler copy] : [NSNull null]}];
	NSInteger index = _buttonsMapping.count - 1;
	NSAssert(index < _buttonsInDesign.count, @"buttons in design is too less");
	UIButton *btn = _buttonsInDesign[index];
	btn.tag = index;
	[btn setTitle:title forState:UIControlStateNormal];
	
	UIColor *color;
	if (isDestructive) {
		color = [UIColor colorWithRed:217./255. green:61./255. blue:12./255. alpha:1];
	} else {
		CGFloat value = _currentRGBValue/255.;
		color = [UIColor colorWithRed:value green:value blue:value alpha:1];
		if (_currentRGBValue > 0) {
			_currentRGBValue -= 10;
		}
	}
	[btn setBackgroundColor:color];
	
	return index;
}

- (void)showInView:(UIView *)view {
	if (view) {
		[view addSubview:self];
		[self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
		
		for (uint i = 0; i < _buttonsInDesign.count; i++) {
			UIButton *btn = _buttonsInDesign[i];
			if (i >= _buttonsMapping.count) {
				NSLayoutConstraint *constraint = [self _getHeightConstraintForButton:btn];
				constraint.constant = 0;
				btn.hidden = YES;
			}
		}
		
		[self layoutIfNeeded];
		[_lblTitle sizeToFit];
		_titleViewHeightConstraint.constant = _lblTitle.height + 40;
		
		[self _setActionSheetShow:YES];
	} else {
		ZPLogDebug(@"view is nil, will not show action sheet");
	}
}

- (IBAction)btnTapped:(UIButton *)sender {
	id object = _buttonsMapping[sender.tag][kHandler];
	if (![object isKindOfClass:[NSNull class]]) {
		ZPVoidBlock handler = _buttonsMapping[sender.tag][kHandler];
		ZPInvokeBlock(handler);
	}
	
	[self _setActionSheetShow:NO];
}

- (void)_setActionSheetShow:(BOOL)show {
//	_contentViewTopConstraint.constant = show ? self.height : 0;
	_contentView.top = show ? self.height : 0;
	_modalView.alpha = show ? 0 : .2;
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		_contentView.top = show ? 0 : self.height;
		[_contentView layoutIfNeeded];
		_modalView.alpha = show ? .2 : 0;
	} completion:^(BOOL finished) {
		if (!show) {
			[self removeFromSuperview];
		}
	}];
}

- (IBAction)tapGestureTapped:(UITapGestureRecognizer *)sender {
	CGPoint point = [sender locationInView:self];
	CGFloat y = _titleView.hidden ? _titleView.bottom : _titleView.top;
	if (point.y < y) {
		[self _setActionSheetShow:NO];
	}
}

@end
