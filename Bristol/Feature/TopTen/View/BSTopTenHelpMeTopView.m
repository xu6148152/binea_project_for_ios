//
//  BSTopTenHelpMeTopView.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenHelpMeTopView.h"
#import "BSAvatarButton.h"
#import "BSAttributedLabel.h"

#import "BSTopTenHelpMeTopHttpRequest.h"
#import "BSHighlightLikeHttpRequest.h"

#import "PureLayout.h"

@interface BSTopTenHelpMeTopView()
{
	
}
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatarShare;
@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblTextShare;

@property (copy, nonatomic) ZPVoidBlock actionButtonCallBack;
@property (strong, nonatomic) BSSportMO *sport;
@property (strong, nonatomic) BSEventMO *event;
@property (strong, nonatomic) BSHighlightMO *highlight;
@property (assign, nonatomic) BOOL actionButtonShare;
@property (assign, nonatomic) BSToptenChannelType toptenChannelType;
@property (assign, nonatomic) NSInteger currentRank;

@end


@implementation BSTopTenHelpMeTopView

+ (void)showWithUser:(BSUserMO *)user sport:(BSSportMO *)sport event:(BSEventMO *)event highlight:(BSHighlightMO *)highlight currentRank:(NSInteger)currentRank toptenChannelType:(BSToptenChannelType)toptenChannelType actionButtonShare:(BOOL)actionButtonShare actionButtonCallBack:(ZPVoidBlock)actionButtonCallBack {
	BSTopTenHelpMeTopView *view = [[[UINib nibWithNibName:@"BSTopTenHelpMeTopView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
	view.actionButtonCallBack = actionButtonCallBack;
	view.sport = sport;
	view.event = event;
	view.highlight = highlight;
	view.currentRank = currentRank;
	view.toptenChannelType = toptenChannelType;
	view.actionButtonShare = actionButtonShare;
	[view.btnAvatarShare configWithUser:user];
	NSString *channel;
	switch (toptenChannelType) {
			default:
		case BSToptenChannelTypeFriends:
			channel = ZPLocalizedString(@"my friends list");
			break;
		case BSToptenChannelTypeEvents:
			channel = event.name;
			break;
		case BSToptenChannelTypeSports:
			channel = sport.nameLocalized;
			break;
	}
	view.lblTextShare.text = [NSString stringWithFormat:ZPLocalizedString(@"Help me to top 10 format"), @(currentRank), channel];
	[view.btnAction setTitle:actionButtonShare ? ZPLocalizedString(@"SEND TO FRIENDS") : ZPLocalizedString(@"LIKE+1") forState:UIControlStateNormal];
	
	[view _setShareViewShow:YES];
}

- (void)_setShareViewShow:(BOOL)show {
	if (show) {
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[window addSubview:self];
		self.alpha = 0;
		[self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
	}
	
	[UIView animateWithDuration:kDefaultAnimateDuration animations:^{
		self.alpha = show ? 1 : 0;
	} completion:^(BOOL finished) {
		if (!show) {
			[self removeFromSuperview];
		}
	}];
}

- (IBAction)btnActionTapped:(UIButton *)sender {
	sender.enabled = NO;
	if (_actionButtonShare) {
		BSTopTenHelpMeTopBaseHttpRequest *request;
		switch (_toptenChannelType) {
			case BSToptenChannelTypeFriends:
				request = [BSTopTenHelpMeTopInFriendHttpRequest request];
				break;
			case BSToptenChannelTypeEvents:
				request = [BSTopTenHelpMeTopInEventHttpRequest request];
				((BSTopTenHelpMeTopInEventHttpRequest *)request).event_id = _event.identifierValue;
				break;
			case BSToptenChannelTypeSports:
				request = [BSTopTenHelpMeTopInSportHttpRequest request];
				((BSTopTenHelpMeTopInSportHttpRequest *)request).sport_type = (NSInteger)_sport.identifierValue;
				break;
		}
		request.current_rank = _currentRank;
		request.highlight_id = _highlight.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			sender.enabled = YES;
			
			[self _setShareViewShow:NO];
			[BSUIGlobal showMessage:ZPLocalizedString(@"Shared to all friends.")];
			
			ZPInvokeBlock(_actionButtonCallBack);
		} failedBlock:^(BSHttpResponseDataModel *result) {
			sender.enabled = YES;
		}];
	} else {
		BOOL isOriginLiked = _highlight.is_likedValue;
		
		BSHighlightLikeHttpRequest *request = [BSHighlightLikeHttpRequest requestWithHighlightId:_highlight.identifierValue];
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			sender.enabled = YES;
			
			[self _setShareViewShow:NO];
			[BSUIGlobal showMessage:ZPLocalizedString(@"You liked this highlight.")];
			
			_highlight.is_likedValue = YES;
			if (!isOriginLiked) {
				_highlight.likes_countValue++;
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightLikeDidLikedNotification object:_highlight];
			[[NSNotificationCenter defaultCenter] postNotificationName:kHighlightLikeDidChangedNotification object:_highlight];
			
			ZPInvokeBlock(_actionButtonCallBack);
		} failedBlock:^(BSHttpResponseDataModel *result) {
			sender.enabled = YES;
		}];
	}
}

- (IBAction)shareViewTapped:(id)sender {
	[self _setShareViewShow:NO];
}

@end
