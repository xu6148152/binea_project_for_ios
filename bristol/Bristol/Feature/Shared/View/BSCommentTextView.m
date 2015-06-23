//
//  BSCommentTextView.m
//  Bristol
//
//  Created by Bo on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCommentTextView.h"

@implementation BSCommentTextView

- (void)layoutSubviews {
	[super layoutSubviews];

	[self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
	CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, FLT_MAX)];

	if (!self.heightConstraint) {
		self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:size.height];
		[self addConstraint:self.heightConstraint];
	}

	self.heightConstraint.constant = size.height;
	[super updateConstraints];
}

@end
