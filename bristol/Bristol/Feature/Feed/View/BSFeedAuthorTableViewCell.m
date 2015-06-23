//
//  BSFeedAuthorTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/17/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedAuthorTableViewCell.h"
#import "BSFeedCommentsViewController.h"
#import "BSAvatarButton.h"
#import "BSActivityIndicatorButton.h"

#import "BSCustomHttpRequest.h"
#import "BSHighlightLikeHttpRequest.h"
#import "BSHighlightUnlikeHttpRequest.h"
#import "BSHighlightGetShareUrlHttpRequest.h"

#import "BSDataManager.h"

#import "ZPFacebookSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPInstagramSharer.h"

#import "UIControl+EventTrack.h"

@interface BSFeedAuthorTableViewCell()
{
	BSCustomHttpRequest *_request;
	UITapGestureRecognizer *_doubleTapGesture;
}

@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblHighlightDescription;

@property (weak, nonatomic) IBOutlet UIView *authorHostView;
@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;

@property (weak, nonatomic) IBOutlet UIView *actionViewWithShare;
@property (weak, nonatomic) IBOutlet UIView *actionViewWithoutShare;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLikeWithoutShare;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCommentWithoutShare;
@property (weak, nonatomic) IBOutlet BSActivityIndicatorButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIButton *btnActionWithoutShare;

@end

@implementation BSFeedAuthorTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoViewDoubleTapped:) name:kHighlightDoubleTappedNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_videoViewDoubleTapped:(NSNotification *)notification {
	_doubleTapGesture = notification.object;
	
	[self btnLikeTapped:_actionViewWithShare.hidden ? _btnLikeWithoutShare : _btnLike];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	if (_highlight != highlight) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:kHighlightLikeDidLikedNotification object:_highlight];
		_highlight = highlight;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateLikeUI) name:kHighlightLikeDidLikedNotification object:_highlight];
		
		[self _updateLikeUI];
		_btnLike.eventTrackProperties = _btnLikeWithoutShare.eventTrackProperties = _btnComment.eventTrackProperties = _btnCommentWithoutShare.eventTrackProperties = _btnAction.eventTrackProperties = _btnActionWithoutShare.eventTrackProperties = _btnShare.eventTrackProperties = [self eventTrackProperties];
		BOOL isCurrentUser = _highlight.user == [BSDataManager sharedInstance].currentUser;
		_actionViewWithShare.hidden = !isCurrentUser;
		_actionViewWithoutShare.hidden = isCurrentUser;
		
		[self configAttributedLabel:_lblHighlightDescription text:_highlight.message commenter:_highlight.user.name_id];
		[_btnAvatar configWithUser:_highlight.user];
	}
}

- (void)_updateLikeUI {
	_btnLike.selected = _btnLikeWithoutShare.selected = _highlight.is_likedValue;
	_btnLike.eventTrackName = _btnLikeWithoutShare.eventTrackName = _highlight.is_likedValue ? @"video_unlike" : @"video_like";
}

- (void)_postToFacebookWithVideoUrl:(NSURL *)url description:(NSString *)description {
	ZPVoidBlock actuallyShare = ^ {
		[BSUIGlobal showMessage:ZPLocalizedString(@"Posting")];
		
		[ZPFacebookSharer shareVideoWithUrl:url title:nil description:description successHandler:^{
			[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Facebook"]];
			[BSEventTracker trackResult:YES eventName:@"facebook_share" page:nil properties:[self eventTrackProperties]];
		} faildHandler:^(NSError *error) {
			[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Facebook", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
				[self _postToFacebookWithVideoUrl:url description:description];
			}];
		}];
	};
	
	if ([ZPFacebookSharer isConnected]) {
		ZPInvokeBlock(actuallyShare);
	} else {
		[ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
			ZPInvokeBlock(actuallyShare);
		} faildHandler:^(NSError *error) {
			[BSUIGlobal showError:error];
		}];
	}
}

- (void)_postToTwitterWithImage:(UIImage *)image description:(NSString *)description {
	ZPVoidBlock actuallyShare = ^ {
		[BSUIGlobal showMessage:ZPLocalizedString(@"Posting")];
		
		[ZPTwitterSharer shareImage:image description:description successHandler:^(NSDictionary *dictionary) {
			[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Twitter"]];
			[BSEventTracker trackResult:YES eventName:@"twitter_share" page:nil properties:[self eventTrackProperties]];
		} faildHandler:^(NSError *error) {
			[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Twitter", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
				[self _postToTwitterWithImage:image description:description];
			}];
		}];
	};
	
	if ([ZPTwitterSharer isConnected]) {
		ZPInvokeBlock(actuallyShare);
	} else {
		[ZPTwitterSharer connectWithSuccessHandler:^(NSString *authToken, NSString *authTokenSecret) {
			ZPInvokeBlock(actuallyShare);
		} faildHandler:^(NSError *error) {
			[BSUIGlobal showError:error];
		}];
	}
}

- (void)_postToInstagramWithVideoUrl:(NSURL *)url description:(NSString *)description {
	if ([ZPInstagramSharer isInstalled]) {
		[ZPInstagramSharer shareVideoWithUrl:url content:description completion:^(NSError *error) {
			if (error) {
				[BSUIGlobal showAlertMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site error format"), @"Instagram", error.localizedDescription] actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
					[self _postToInstagramWithVideoUrl:url description:description];
				}];
			} else {
				[BSUIGlobal showMessage:[NSString stringWithFormat:ZPLocalizedString(@"Post highlight to social site success format"), @"Instagram"]];
				[BSEventTracker trackResult:YES eventName:@"instagram_share" page:nil properties:[self eventTrackProperties]];
			}
		}];
	} else {
		[BSUIGlobal showMessage:ZPLocalizedString(@"Instagram not installed")];
	}
}

- (IBAction)btnLikeTapped:(UIButton *)sender {
	sender.enabled = _doubleTapGesture.enabled = NO;
	
	[_request cancelRequest];
	
	BOOL isLiked = _highlight.is_likedValue;
	if (isLiked) {
		_request = [BSHighlightUnlikeHttpRequest requestWithHighlightId:_highlight.identifierValue];
	} else {
		_request = [BSHighlightLikeHttpRequest requestWithHighlightId:_highlight.identifierValue];
	}
	
	_highlight.is_likedValue = !isLiked;
	_highlight.likes_countValue += (isLiked ? -1 : 1);
	[self _updateLikeUI];
	
	[_request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightLikeDidChangedNotification object:_highlight];
		sender.enabled = _doubleTapGesture.enabled = YES;
	} failedBlock:^(BSHttpResponseDataModel *result) {
		_highlight.is_likedValue = isLiked;
		_highlight.likes_countValue += (isLiked ? 1 : -1);
		[self _updateLikeUI];
		sender.enabled = _doubleTapGesture.enabled = YES;
	}];
}

- (IBAction)btnCommentTapped:(id)sender {
	[BSUtility pushViewController:[BSFeedCommentsViewController instanceWithHighlight:_highlight showKeyboard:YES]];
}

- (IBAction)btnShareTapped:(BSActivityIndicatorButton *)sender {
	if (_highlight.local_share_url) {
		if ([_delegate respondsToSelector:@selector(feedAuthorTableViewCell:willTapShareButton:)]) {
			[_delegate feedAuthorTableViewCell:self willTapShareButton:sender];
		}
		
		NSURL *videoUrl = [NSURL fileURLWithPath:[[BSDataManager sharedInstance] getVideoFullPathForHighlight:_highlight]];
		NSString *description = [NSString stringWithFormat:ZPLocalizedString(@"Share highlight to social site format"), _highlight.user.name_human_readable, _highlight.local_share_url];
		
		[BSUIGlobal showActionSheetTitle:nil isDestructive:NO actionTitle:ZPLocalizedString(@"Share to Facebook") actionHandler:^{
			[self _postToFacebookWithVideoUrl:videoUrl description:description];
		} additionalConstruction:^(BSUIActionSheet *actionSheet) {
			[actionSheet addButtonWithTitle:ZPLocalizedString(@"Share to Twitter") isDestructive:NO handler:^{
				NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_highlight.cover_url]];
				UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:key];
				[self _postToTwitterWithImage:image description:description];
			}];
			[actionSheet addButtonWithTitle:ZPLocalizedString(@"Share to Instagram") isDestructive:NO handler:^{
				[self _postToInstagramWithVideoUrl:videoUrl description:description];
			}];
		}];
	} else {
		sender.enabled = NO;
		[sender showActivityIndicator:YES];
		BSHighlightGetShareUrlHttpRequest *request = [BSHighlightGetShareUrlHttpRequest requestWithHighlightId:_highlight.identifierValue];
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			_highlight.local_share_url = ((BSHighlightShareUrlDataModel *)result.dataModel).url;
			[self btnShareTapped:sender];
			
			sender.enabled = YES;
			[sender showActivityIndicator:NO];
		} failedBlock:^(BSHttpResponseDataModel *result) {
			sender.enabled = YES;
			[sender showActivityIndicator:NO];
		}];
	}
	
}

- (IBAction)btnActionTapped:(id)sender {
	if ([_delegate respondsToSelector:@selector(feedAuthorTableViewCell:didTapActionButton:)]) {
		[_delegate feedAuthorTableViewCell:self didTapActionButton:sender];
	}
}

# pragma mark - event tracking
- (NSDictionary *) eventTrackProperties {
	return @{@"video_id":_highlight.identifier};
}

@end
