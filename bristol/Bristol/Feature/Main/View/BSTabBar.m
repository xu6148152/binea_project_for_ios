//
//  BSTabBar.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTabBar.h"
#import "BSTabBarItemBGView.h"
#import "UIImage+Resize.h"

#import "PureLayout.h"

@interface BSTabBar()
{
	BSTabBarItemBGView *_bgView;
	NSUInteger _selectedIndex;
}

@end

@implementation BSTabBar

- (UIImage *)_generateTabbarBGImage {
	CGSize size = self.bounds.size;
	size.width = [UIScreen mainScreen].bounds.size.width;
	
	UIColor *coverColor = [UIColor whiteColor];
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [coverColor CGColor]);
	CGRect rect = CGRectMake(0, 0, size.width * 2 / 5, size.height);
	CGContextFillRect(context, rect);
	rect = CGRectMake(size.width * 3 / 5, 0, size.width * 2 / 5, size.height);
	CGContextFillRect(context, rect);
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.backgroundColor = [UIColor clearColor];
	self.tintColor = [UIColor blackColor];
	for (UITabBarItem *item in self.items) {
		item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	}
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[self _generateTabbarBGImage]];
	[self addSubview:imageView];
	
	_bgView = [[[UINib nibWithNibName:@"BSTabBarItemBGView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
	[self addSubview:_bgView];
	
	_selectedIndex = NSNotFound;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	for (UIImageView *view in self.subviews) {
		if ([view isKindOfClass:[UIImageView class]] && view.height <= 1) {
			view.hidden = YES;
		}
	}
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
	[super setSelectedItem:selectedItem];
	
	NSUInteger index = [self.items indexOfObject:selectedItem];
	if (index != _selectedIndex) {
		_selectedIndex = index;
		
		CGFloat left = self.width * index / self.items.count;
		static CGFloat PADDING = 5;
		[UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			_bgView.frame = CGRectMake(left, -PADDING, self.width/5, self.height + PADDING);
		} completion:^(BOOL finished) {
			
		}];
	}
}

@end
