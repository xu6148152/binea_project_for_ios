//
//  BSCommentTextView.m
//  Bristol
//
//  Created by Bo on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCommentTextView.h"

@interface BSCommentTextView()

@property (nonatomic, assign) CGFloat maxHeightConstraint;
@property (nonatomic, assign) BOOL isMaxHeight;

@end

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
    
    if (self.maxHeight > 0) {
        if (size.height >= self.maxHeight) {
            if (self.isMaxHeight == false) {
                self.isMaxHeight = YES;
                self.maxHeightConstraint = self.maxHeight;
            }
            
            self.heightConstraint.constant = self.maxHeightConstraint;
            self.scrollEnabled = YES;
        } else{
            self.heightConstraint.constant = size.height;
        }
    } else {
        self.heightConstraint.constant = size.height;
    }
    
	[super updateConstraints];
}

@end
