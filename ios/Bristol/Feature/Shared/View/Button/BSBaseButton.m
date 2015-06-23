//
//  BSBaseButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseButton.h"

@implementation BSBaseButton

- (void)_setDefaults {
	self.adjustsImageWhenHighlighted = kShowHighlightWhenTapDown;
	self.adjustsImageWhenDisabled = NO;
	
	_imageDesignedOfNormal = [self imageForState:UIControlStateNormal];
	_imageDesignedOfHighlighted = [self imageForState:UIControlStateHighlighted];
	_imageDesignedOfSelected = [self imageForState:UIControlStateSelected];
	_imageDesignedOfDisabled = [self imageForState:UIControlStateDisabled];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _setDefaults];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self _setDefaults];
}

@end
