//
//  BSTextField.m
//  Bristol
//
//  Created by Yangfan Huang on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTextField.h"

@implementation BSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
	if (self = [super init]) {
		[self _configureClearButton];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self _configureClearButton];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self _configureClearButton];
	}
	
	return self;
}

- (void) _configureClearButton {
	UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[clearButton setImage:[UIImage imageNamed:@"common_header_close"] forState:UIControlStateNormal];
	[clearButton setFrame:CGRectMake(0, 0, 42, 20)];
	clearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
	[clearButton addTarget:self action:@selector(_clearText) forControlEvents:UIControlEventTouchUpInside];
	
	self.rightViewMode = self.clearButtonMode;
	self.rightView = clearButton;
	self.clearButtonMode = UITextFieldViewModeNever;
}

- (void) _clearText {
	if (!self.delegate || ![self.delegate respondsToSelector:@selector(textFieldShouldClear:)] || [self.delegate textFieldShouldClear:self]) {
		self.text = @"";
		[self endEditing:YES];
	}
}

// placeholder position
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectMake(bounds.origin.x + 22, bounds.origin.y, bounds.size.width - 70, bounds.size.height);
}


@end
