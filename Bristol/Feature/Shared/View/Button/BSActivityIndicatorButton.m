//
//  BSActivityIndicatorButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSActivityIndicatorButton.h"

@interface BSActivityIndicatorButton()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end


@implementation BSActivityIndicatorButton

- (void)_commitInit {
	
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self _commitInit];
}

- (UIActivityIndicatorView *)indicator {
	if (!_indicator) {
		_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:_indicator];
	}
	return _indicator;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (_indicator) {
		[self bringSubviewToFront:_indicator];
		_indicator.center = CGPointMake(self.width / 2, self.height / 2);
	}
}

- (void)showActivityIndicator:(BOOL)show {
	if (show) {
		self.indicator.hidden = NO;
		[self.indicator startAnimating];
	} else {
		self.indicator.hidden = YES;
		[self.indicator stopAnimating];
	}
}

@end
