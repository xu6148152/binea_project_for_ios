//
//  NSString+Validation.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/2/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidExpression:(NSString *)expression {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];

	return numberOfMatches != 0;
}

- (BOOL)isValidDigit {
	return [self isValidExpression:@"^([0-9]+)?$"];
}

- (BOOL)isValidUserID {
    NSString *idRegex = @"[A-Za-z0-9._]{5,30}";
    NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", idRegex];
    return [idTest evaluateWithObject:self];
}

- (BOOL)isValidUserName {
	return self.length >= 2 && self.length <= 30;
}

- (BOOL)isValidEmail {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPassword {
	return self.length >= 6 && self.length <= 20;
}

@end
