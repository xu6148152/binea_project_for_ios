//
//  NSString+Validation.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Validation)

- (BOOL)isValidExpression:(NSString *)expression;
- (BOOL)isValidDigit;

- (BOOL)isValidUserName;
- (BOOL)isValidUserID;
- (BOOL)isValidEmail;
- (BOOL)isValidPassword;

@end
