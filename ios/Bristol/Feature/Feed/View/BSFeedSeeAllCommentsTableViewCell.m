//
//  BSFeedSeeAllCommentsTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedSeeAllCommentsTableViewCell.h"

@interface BSFeedSeeAllCommentsTableViewCell()
{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UIView *multiplyBlendView;

@end

@implementation BSFeedSeeAllCommentsTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configWithCommentsCount:(NSUInteger)count {
	NSString *format = count == 3 ? ZPLocalizedString(@"See comments format") : ZPLocalizedString(@"See all comments format");
	_lblComments.text = [NSString stringWithFormat:format, count];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	_isTapInMultiplyBlendViewArea = CGRectContainsPoint(_multiplyBlendView.frame, point);
	
	[super touchesEnded:touches withEvent:event];
}

@end
