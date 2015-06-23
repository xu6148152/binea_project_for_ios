//
//  BSTabBarItemBGView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTabBarItemBGView.h"

@interface BSTabBarItemBGView()
{
	
}
@property (weak, nonatomic) IBOutlet UIView *blurView;

@end


@implementation BSTabBarItemBGView

- (void)awakeFromNib {
	[super awakeFromNib];
	
//	_blurView.dynamic = YES;
}

@end
