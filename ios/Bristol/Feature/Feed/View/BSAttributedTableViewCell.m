//
//  BSAttributedTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAttributedTableViewCell.h"

static NSString *kHashTagAndMentionRegex = @"(#|@)(\\w+)";

@implementation BSAttributedTableViewCell

- (void)configAttributedLabel:(BSAttributedLabel *)commentLabel text:(NSString *)text commenter:(NSString *)commenter {
	NSString *commentText;
	if (commenter) {
		commenter = [commenter uppercaseString];
		commentText = [NSString stringWithFormat:@"%@ %@", commenter, text];
	}
	else {
		commentText = text;
	}

    [self addLinkWithText:commentText forAttributeLabel:commentLabel commenter:commenter];
}

- (void)addLinkWithText:(NSString *)commentText forAttributeLabel:(BSAttributedLabel *)commentLabel commenter:(NSString *)commenter {
    NSMutableArray *textCheckingResults = [NSMutableArray array];
    [commentLabel setText:commentText afterInheritingLabelAttributesAndConfiguringWithBlock: ^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange searchRange = NSMakeRange(0, [mutableAttributedString length]);
        
        if (commenter) {
            NSRange currentRange = [[mutableAttributedString string] rangeOfString:commenter options:NSLiteralSearch range:searchRange];
            NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:currentRange URL:nil];
            [textCheckingResults addObject:result];
        }
        
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kHashTagAndMentionRegex options:NSRegularExpressionCaseInsensitive error:&error];
        if (error) {
            ZPLogError(@"%@", error);
        }
        
        [regex enumerateMatchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, [mutableAttributedString length]) usingBlock: ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [textCheckingResults addObject:result];
        }];
        
        return mutableAttributedString;
    }];
    
    for (NSTextCheckingResult *result in textCheckingResults) {
        [commentLabel addLinkWithTextCheckingResult:result];
    }
}

@end
