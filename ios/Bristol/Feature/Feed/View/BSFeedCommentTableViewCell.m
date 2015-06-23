//
//  BSFeedCommentTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedCommentTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSDataManager.h"

@interface BSFeedCommentTableViewCell () <TTTAttributedLabelDelegate>
{
	id _bindingObject;
}
@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblContent;
@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIView *multiplyBlendView;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end


@implementation BSFeedCommentTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	_lblContent.delegate = self;
}

- (void)configWithComment:(BSCommentMO *)comment showCommenter:(BOOL)showCommenter {
	_bindingObject = comment;

	[self configAttributedLabel:_lblContent text:comment.content commenter:showCommenter ? comment.user.name_id : nil];
	[_lblName setText:comment.user.name_id.uppercaseString];
	[_lblDate setText:[BSUtility timesAgoOfDate:comment.created_at]];
    [_btnAvatar configWithUser:comment.user];
    
    self.userInteractionEnabled = !comment.highlight.local_is_wait_for_postValue;
}

- (void)configWithHighlight:(BSHighlightMO *)highlight showCommenter:(BOOL)showCommenter {
	_bindingObject = highlight;
	
	[self configAttributedLabel:_lblContent text:highlight.message commenter:showCommenter ? highlight.user.name_id : nil];
	[_lblName setText:highlight.user.name_id.uppercaseString];
	[_lblDate setText:[BSUtility timesAgoOfDate:highlight.created_at]];
	[_btnAvatar configWithUser:highlight.user];
	
	self.userInteractionEnabled = !highlight.local_is_wait_for_postValue;
}

- (void)configWithDataModel:(id)dataModel showCommenter:(BOOL)showCommenter {
	if ([dataModel isKindOfClass:[BSCommentMO class]]) {
		[self configWithComment:dataModel showCommenter:showCommenter];
	} else if ([dataModel isKindOfClass:[BSHighlightMO class]]) {
		[self configWithHighlight:dataModel showCommenter:showCommenter];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	_isTapInMultiplyBlendViewArea = CGRectContainsPoint(_multiplyBlendView.frame, point);
	
	[super touchesEnded:touches withEvent:event];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
	NSString *selectedText = [[label.attributedText string] substringWithRange:result.range];

	if ([selectedText hasPrefix:@"http://"] || [selectedText hasPrefix:@"https://"]) {
		NSURL *selectedURL = [NSURL URLWithString:selectedText];

		if (selectedURL) {
			if ([self.delegate respondsToSelector:@selector(feedCommentCell:didSelectURL:)]) {
				[self.delegate feedCommentCell:self didSelectURL:selectedURL];
			}
			return;
		}
	}
	else if ([selectedText hasPrefix:@"#"]) {
		NSString *hashtag = [selectedText substringFromIndex:1];

		if ([self.delegate respondsToSelector:@selector(feedCommentCell:didSelectHashtag:)]) {
			[self.delegate feedCommentCell:self didSelectHashtag:hashtag];
		}
	}
	else if ([selectedText hasPrefix:@"@"]) {
		NSString *mention = [selectedText substringFromIndex:1];

		if ([self.delegate respondsToSelector:@selector(feedCommentCell:didSelectMention:)]) {
			[self.delegate feedCommentCell:self didSelectMention:mention];
		}
	}
	else if ([self.delegate respondsToSelector:@selector(feedCommentCell:didSelectCommenter:)]) {
		BSUserMO *user = [_bindingObject isKindOfClass:[BSCommentMO class]] ? ((BSCommentMO *)_bindingObject).user : ((BSHighlightMO *)_bindingObject).user;
		[self.delegate feedCommentCell:self didSelectCommenter:user];
	}
}

@end
