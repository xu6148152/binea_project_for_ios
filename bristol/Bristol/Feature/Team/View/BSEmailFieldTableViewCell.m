//
//  BSEmailFieldTableViewCell.m
//  Bristol
//
//  Created by Yangfan Huang on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSEmailFieldTableViewCell.h"
#import "BSUIGlobal.h"

@interface BSEmailFieldTableViewCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) NSUInteger row;
@end

@implementation BSEmailFieldTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) configureRow:(NSUInteger)row email:(NSString *)email {
	[self.emailTextField setText:email];
	self.emailTextField.delegate = self;
	self.row = row;
}

- (void) beginEditing {
	[self.emailTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (self.delegate) {
		[self.delegate rowDidBeginEditing:self.row];
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (!textField.text || textField.text.length == 0 || [textField.text isValidEmail]) {
		textField.textColor = [UIColor blackColor];
		return YES;
	} else {
		textField.textColor = [BSUIGlobal alertColor];
		[textField shakeAnimation];
		return NO;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	/*if (self.delegate) {
		[self.delegate row:self.row didInputEmail:textField.text];
	}*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:NO];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	dispatch_async(dispatch_get_main_queue(), ^{
		[textField endEditing:YES];
	});
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *input = [textField.text stringByReplacingCharactersInRange:range withString:string];
	textField.textColor = [UIColor blackColor];
	if (self.delegate) {
		[self.delegate row:self.row didInputEmail:input];
	}
	return YES;
}

@end
