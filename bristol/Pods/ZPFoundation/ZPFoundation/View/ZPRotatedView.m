//
//  ZPRotatedView.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/8/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPRotatedView.h"
#import "ZPGeometry.h"

@implementation ZPRotatedView

- (void)_commitInit {
    _rotateAngle = 45;
	self.transform = CGAffineTransformMakeRotation(degrees2Radian(_rotateAngle));
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

@end
