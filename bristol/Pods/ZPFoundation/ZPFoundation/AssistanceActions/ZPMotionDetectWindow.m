//
//  ZPMotionDetectWindow.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPMotionDetectWindow.h"
#import "ZPAssistanceWindow.h"

@implementation ZPMotionDetectWindow
{
	ZPAssistanceWindow *_asstanceWindow;
}

- (void)_commitInit {
	if (!_asstanceWindow) {
		_asstanceWindow = [ZPAssistanceWindow new];
		_asstanceWindow.originalKeyWindow = self;
	}
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"WindowMotionDetectedNotification" object:nil userInfo:@{ @"EventSubtype" : @(motion), @"Event" : event }];
}

@end
