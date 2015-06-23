//
//  BSFeedUploadingTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/18/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedUploadingTableViewCell.h"
#import "BSDataManager.h"

#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"

@interface BSFeedUploadingTableViewCell()
{
}
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHL;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;

@end


#define kGreenColor ([UIColor colorWithRed255:199 green255:226 blue255:18 alphaFloat:1])
#define kRedColor ([UIColor colorWithRed255:217 green255:61 blue255:12 alphaFloat:1])

@implementation BSFeedUploadingTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_progressViewTrailingConstraint.constant = self.width;
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	if (_highlight != highlight) {
		_highlight = highlight;
		
		_imgViewHL.image = [UIImage imageWithContentsOfFile:highlight.local_cover_path];
		[self _post];
	}
}

- (IBAction)btnCancelTapped:(id)sender {
	if ([_delegate respondsToSelector:@selector(feedUploadingCell:didTapCloseButton:)]) {
		[_delegate feedUploadingCell:self didTapCloseButton:sender];
	}
}

- (IBAction)btnRetryTapped:(id)sender {
	[self _post];
}

#pragma mark - post
- (void)_setProgress:(float)progress {
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		_progressViewTrailingConstraint.constant = (1 - progress) * self.width;
		[_progressView layoutIfNeeded];
	}];
}

- (void)_post {
	[[BSDataManager sharedInstance] postLocalHighlight:_highlight progress:^(float value) {
		[self _setProgress:value];
		_progressView.backgroundColor = kGreenColor;
		_btnCancel.hidden = _btnRetry.hidden = YES;
		_lblMessage.text = ZPLocalizedString(@"Posting");
	} success:^{
		[self _setProgress:1];
		_progressView.backgroundColor = kGreenColor;
		_btnCancel.hidden = _btnRetry.hidden = YES;
		_lblMessage.text = ZPLocalizedString(@"Successful");
		
		[self _postToSNSSite];
		
		[[NSFileManager defaultManager] removeItemAtPath:_highlight.local_cover_path error:nil];
	} faild:^(NSError *error) {
		[self _setProgress:1];
		_progressView.backgroundColor = kRedColor;
		_btnCancel.hidden = _btnRetry.hidden = NO;
		_lblMessage.text = ZPLocalizedString(@"Failed");
	}];
}

- (void)_postToSNSSite {
	if (!_highlight.video_url) {
		_highlight.video_url = @"";
	}
	NSString *message = [NSString stringWithFormat:ZPLocalizedString(@"Share highlight to social site format"), [BSDataManager sharedInstance].currentUser.name_human_readable, _highlight.video_url];
	NSURL *videoUrl = [NSURL URLWithString:_highlight.local_video_path];
	
	NSArray *types = [_highlight.local_share_types componentsSeparatedByString:@","];
	if ([types containsObject:kHighlightShareTypeFacebook]) {
		[self _postToFacebookWithUrl:videoUrl title:nil description:_highlight.message];// custom text without using user writed text is not allow by Facebook
	}
	if ([types containsObject:kHighlightShareTypeTwitter]) {
		UIImage *image = [UIImage imageWithContentsOfFile:_highlight.local_cover_path];
		[self _postToTwitterWithTitle:nil description:message image:image];
	}
	if ([types containsObject:kHighlightShareTypeInstagram]) {
		[BSUIGlobal showAlertMessage:ZPLocalizedString(@"Do you want to share highlight to Instagram") actionTitle:ZPLocalizedString(@"Sure") actionHandler:^{
			[self _postToInstagramWithUrl:videoUrl description:message];
		}];
	}
}

- (void)_postToFacebookWithUrl:(NSURL *)url title:(NSString *)title description:(NSString *)description {
	[ZPFacebookSharer shareVideoWithUrl:url title:title description:description successHandler:^{
		[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Facebook"]];
	} faildHandler:^(NSError *error) {
		[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Facebook", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
			[self _postToFacebookWithUrl:url title:title description:description];
		}];
	}];
}

- (void)_postToTwitterWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image {
	[ZPTwitterSharer shareImage:image description:description successHandler:^(NSDictionary *dictionary) {
		[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Twitter"]];
	} faildHandler:^(NSError *error) {
		[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Twitter", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
			[self _postToTwitterWithTitle:title description:description image:image];
		}];
	}];
}

- (void)_postToInstagramWithUrl:(NSURL *)url description:(NSString *)description {
	[ZPInstagramSharer shareVideoWithUrl:url content:description completion:^(NSError *error) {
		if (error) {
			[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Instagram", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
				[self _postToInstagramWithUrl:url description:description];
			}];
		} else {
			[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Instagram"]];
		}
	}];
}

@end
