//
//  BSProfileNotificationTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileNotificationTableViewCell.h"
#import "BSAvatarButton.h"
#import "BSHighlightButton.h"
#import "BSLikeOrInviteButton.h"
#import "BSAttributedLabel.h"

#import "BSProfileViewController.h"

#import "BSTeamAcceptInvitationHttpRequest.h"
#import "BSTeamRejectInvitationHttpRequest.h"
#import "BSUserAcceptRequestToFollowHttpRequest.h"
#import "BSUserRejectRequestToFollowHttpRequest.h"

#import "BSDataModels.h"

@interface BSProfileNotificationTableViewCell() <TTTAttributedLabelDelegate>
{
	ZPVoidBlock _attributedTextTapAciton;
}

@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIView *rightHostView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHostViewWidthConstraint;
@property (weak, nonatomic) IBOutlet BSHighlightButton *btnHighlight;
@property (weak, nonatomic) IBOutlet BSLikeOrInviteButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnIgnore;
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblContent;

@end

@implementation BSProfileNotificationTableViewCell

#define kHighlightColor ([UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1])

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_lblContent.delegate = self;
    _lblContent.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
}

- (void)_showHighlightButton:(BOOL)highlight likeButton:(BOOL)like acceptButton:(BOOL)accept {
	_btnHighlight.hidden = !highlight;
	_btnLike.hidden = !like;
	_btnAccept.hidden = !accept;
	_btnIgnore.hidden = !accept;
	
	if (accept) {
		_rightHostViewWidthConstraint.constant = 110;
	} else if (highlight || like) {
		_rightHostViewWidthConstraint.constant = _rightHostView.height;
	} else {
		_rightHostViewWidthConstraint.constant = 0;
	}
}

- (void)configWithNotification:(BSNotificationMO *)notification {
	_notification = notification;
	BSNotificationMO *notificationOfTypeHelpMeTop = nil;
	
	[_btnAvatar configWithUser:notification.user];
	[_btnLike configWithUser:notification.user];
	[_btnUser setTitle:notification.user.name_id forState:UIControlStateNormal];
	
	[_lblContent setLinkAttributesWithColor:[UIColor colorWithRed255:133.0 green255:133.0 blue255:133.0 alphaFloat:1.0]];

    NSString *dayAgoText = [BSUtility timesAgoOfDate:notification.created_at];
	_attributedTextTapAciton = nil;
    __weak typeof(self) weakSelf = self;
	switch (_notification.notification_typeValue) {
		case BSNotificationTypeLike: // 1
            [self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Liked it.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			break;
		case BSNotificationTypeMentionMeInHighlight:
            [self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Mentioned you in a highlight.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			break;
		case BSNotificationTypeComment: // 3
		{
			NSString *comment = notification.comment.content ?: @"";
            NSString *content = [NSString stringWithFormat:ZPLocalizedString(@"Left a comment format"), comment];
            [self _configAttributedLabelWithTextFormat:content highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			break;
		}
		case BSNotificationTypeUserDirectToFollowMe:
            [self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Started following you.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:YES acceptButton:NO];
			break;
		case BSNotificationTypeTeamInviteMeToJoin: // 5
        {
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Invited you to join a team format") highlightText:notification.team.name dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:NO acceptButton:YES];
			break;
        }
		case BSNotificationTypeTeamApproveJoinRequest:
            [self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Accepted your joining request.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:NO acceptButton:NO];
			break;
		case BSNotificationTypeTeamSomeoneJoin: // 7
        {
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Joined a team format") highlightText:notification.team.name dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:YES acceptButton:NO];
			
            _attributedTextTapAciton = ^ {
                [weakSelf _showProfileTeam];
			};
			break;
        }
		case BSNotificationTypeSocialFriendJoined:
        {
			// TODO:
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Joined a team format") highlightText:notification.team.name dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:YES acceptButton:NO];
			
            _attributedTextTapAciton = ^ {
                [weakSelf _showProfileTeam];
			};
			break;
        }
		case BSNotificationTypeHighlightTopTen: // 9
        {
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Your highlight listed in top 10 format") highlightText:notification.team.name dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			
            _attributedTextTapAciton = ^ {
                [weakSelf _showProfileTeam];
			};
			break;
		}
		case BSNotificationTypeMentionMeInComment:
		{
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Mentioned you in a comment.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			break;
		}
		case BSNotificationTypeUserRequestToFollowMe: // 11
		{
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Request to follow.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:NO acceptButton:YES];
			break;
		}
		case BSNotificationTypeAcceptRequestToFollowMe:
		{
			[self _configAttributedLabelWithTextFormat:ZPLocalizedString(@"Accepted your following request.") highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:NO likeButton:NO acceptButton:NO];
			break;
		}
		case BSNotificationTypeHelpMeTop: // 13
		{
			notificationOfTypeHelpMeTop = notification;
			[self _configAttributedLabelWithTextFormat:[notification formatedTextForTypeHelpMeTop] highlightText:nil dayAgoText:dayAgoText];
			[self _showHighlightButton:YES likeButton:NO acceptButton:NO];
			break;
		}
	}
	
	[_btnHighlight configWithHighlight:notification.highlight notification:notificationOfTypeHelpMeTop];
}

- (void)_configAttributedLabelWithTextFormat:(NSString *)textFormat highlightText:(NSString *)highlightText dayAgoText:(NSString *)dayAgoText {
	if (textFormat.length == 0 || dayAgoText.length == 0) {
		return;
	}
    
    NSString *fullText;
    NSRange highlightRange = NSMakeRange(0, 0);
    NSMutableArray *textCheckingResults = [NSMutableArray array];
	NSRange formatRange = [textFormat rangeOfString:@"%@"];
    if (formatRange.length == 0) {
        fullText = [NSString stringWithFormat:@"%@  %@", textFormat, dayAgoText];
    } else {
        highlightText = highlightText.uppercaseString;
        fullText = [NSString stringWithFormat:textFormat, highlightText];
        fullText = [NSString stringWithFormat:@"%@  %@", fullText, dayAgoText];
        highlightRange = NSMakeRange(formatRange.location, highlightText.length);
    }
    NSRange dayAgoRange = [fullText rangeOfString:dayAgoText options:NSBackwardsSearch];
    
	[_lblContent setText:fullText afterInheritingLabelAttributesAndConfiguringWithBlock: ^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        if (highlightRange.length > 0) {
            NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:highlightRange URL:nil];
            [textCheckingResults addObject:result];
        }
        if (dayAgoRange.length > 0) {
            UIFont *baseFont = [UIFont fontWithName:@"Avenir-LightOblique" size:12];
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:dayAgoRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:dayAgoRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:kHighlightColor range:dayAgoRange];
            CFRelease(fontRef);
        }
		
		return mutableAttributedString;
	}];
	
	for (NSTextCheckingResult *result in textCheckingResults) {
		[_lblContent addLinkWithTextCheckingResult:result];
	}
}

- (void)_showProfileTeam {
    [BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithTeam:_notification.team]];
}

- (void)_showProfileUser {
    [BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:_notification.user]];
}

- (void)acceptOrIgnoreTeamInvitation:(BOOL)accept {
	__weak typeof(self) weakSelf = self;
	
	if (_notification.notification_typeValue == BSNotificationTypeTeamInviteMeToJoin) {
		[BSUIGlobal showLoadingWithMessage:nil];
		
		BSTeamBaseHttpRequest *request = accept ? [BSTeamAcceptInvitationHttpRequest request] : [BSTeamRejectInvitationHttpRequest request];
		request.teamId = _notification.team.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSUIGlobal hideLoading];
			
			_notification.team.is_invitedValue = NO;
			[self _showHighlightButton:NO likeButton:NO acceptButton:NO];
			
			if (accept) {
				[_notification.team addMembersObject:[BSDataManager sharedInstance].currentUser];
				_notification.team.members_countValue++;
				_notification.team.is_memberValue = YES;
				[[NSNotificationCenter defaultCenter] postNotificationName:kFollowStateDidChangedNotification object:_notification.team];
				[[NSNotificationCenter defaultCenter] postNotificationName:kTeamDidAddedNotification object:_notification.team];
			}
			[weakSelf.delegate didRemoveNotificationCell:self];
		} failedBlock:nil];
	} else if (_notification.notification_typeValue == BSNotificationTypeUserRequestToFollowMe) {
		[BSUIGlobal showLoadingWithMessage:nil];
		
		BSUserBaseHttpRequest *request = accept ? [BSUserAcceptRequestToFollowHttpRequest request] : [BSUserRejectRequestToFollowHttpRequest request];
		request.user_id = _notification.user.identifierValue;
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			[BSUIGlobal hideLoading];
			
			[self _showHighlightButton:NO likeButton:NO acceptButton:NO];
			
			if (accept) {
				[BSDataManager sharedInstance].currentUser.followers_countValue++;
			}
			[weakSelf.delegate didRemoveNotificationCell:self];
		} failedBlock:nil];
	}
}

- (IBAction)btnUserTapped:(id)sender {
    [self _showProfileUser];
}

- (IBAction)btnAcceptTapped:(id)sender {
	[self acceptOrIgnoreTeamInvitation:YES];
}

- (IBAction)btnIgnoreTapped:(id)sender {
	[self acceptOrIgnoreTeamInvitation:NO];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
	ZPInvokeBlock(_attributedTextTapAciton);
}

@end
