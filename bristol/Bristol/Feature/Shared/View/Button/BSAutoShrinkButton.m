//
//  BSAutoShrinkButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/27/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAutoShrinkButton.h"

@implementation BSAutoShrinkButton

- (void)awakeFromNib {
	[super awakeFromNib];

	self.titleLabel.textAlignment = NSTextAlignmentRight;
	self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (CGSize)intrinsicContentSize {
	CGSize size = [self.titleLabel intrinsicContentSize];

	return size;
}

@end
