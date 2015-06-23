//
//  BSNavigationBar.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/28/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSNavigationBar.h"

@implementation BSNavigationBar

- (void)layoutSubviews {
	[super layoutSubviews];

	for (UIView *view in self.subviews) {
		if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationItemView"]) {
			CGRect frame = view.frame;
			view.frame = CGRectMake((self.width - frame.size.width) / 2, frame.origin.y, frame.size.width, frame.size.height);
		}
		/*
		else if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationItemButtonView"]) {
			view.top = 0;
		}*/
	}
}

@end
