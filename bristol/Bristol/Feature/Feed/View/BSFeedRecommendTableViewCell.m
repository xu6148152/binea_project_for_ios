//
//  BSFeedRecommendTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedRecommendTableViewCell.h"
#import "BSProfileAvatarCollectionViewCell.h"
#import "BSAttributedLabel.h"

#import "BSProfileViewController.h"

#import "BSEventCloseFromTimelineHttpRequest.h"
#import "BSTeamCloseFromTimelineHttpRequest.h"
#import "BSEventTracker.h"

@interface BSFeedRecommendTableViewCell() <TTTAttributedLabelDelegate>
{
	BSTeamMO *_team;
	BSEventMO *_event;
	BOOL _isTeamData;
	NSArray *_users;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnName;
@property (weak, nonatomic) IBOutlet BSAttributedLabel *lblDescription;
@property (weak, nonatomic) IBOutlet BSAvatarButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMembers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewMembersHeighConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDecorationTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDecorationBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;

@end


@implementation BSFeedRecommendTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_imgViewDecorationTop.image = [_imgViewDecorationTop.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
	_imgViewDecorationBottom.image = [_imgViewDecorationBottom.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
	
	_lblDescription.delegate = self;
	_lblDescription.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName : [UIColor colorWithRed255:209 green255:238 blue255:0 alphaFloat:1], (NSString *)kCTUnderlineStyleAttributeName : @(NO) };
	_lblDescription.activeLinkAttributes = @{ (NSString *)kCTForegroundColorAttributeName : [UIColor blueColor], (NSString *)kCTUnderlineStyleAttributeName : @(NO) };
	_lblDescription.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
	
	[_collectionViewMembers registerNib:[UINib nibWithNibName:BSProfileAvatarCollectionViewCell.className bundle:nil] forCellWithReuseIdentifier:BSProfileAvatarCollectionViewCell.className];
}

- (id)bindingData {
	return _event ?: _team;
}

- (void)_formatDescriptionWithText:(NSString *)text {
	if (text) {
		NSString *joinUs = ZPLocalizedString(@"Come and JOIN US");
		text = [NSString stringWithFormat:@"%@ %@", text, joinUs];
		NSMutableArray *textCheckingResults = [NSMutableArray array];
		[_lblDescription setText:text afterInheritingLabelAttributesAndConfiguringWithBlock: ^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
			NSRange searchRange = NSMakeRange(0, [mutableAttributedString length]);
			
			NSRange currentRange = [[mutableAttributedString string] rangeOfString:@"JOIN US" options:NSLiteralSearch range:searchRange];
			NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:currentRange URL:nil];
			[textCheckingResults addObject:result];
			
			return mutableAttributedString;
		}];
		
		for (NSTextCheckingResult *result in textCheckingResults) {
			[_lblDescription addLinkWithTextCheckingResult:result];
		}
	}
}

- (void)configWithTeam:(BSTeamMO *)team {
	_team = team;
	_users = _team.membersSortedByAlphabet;
	_isTeamData = YES;
	
	_lblTitle.text = ZPLocalizedString(@"RECOMMENDED TEAM");
	[self _formatDescriptionWithText:team.name.uppercaseString];
	[_btnName setTitle:team.name.uppercaseString forState:UIControlStateNormal];
	[_btnAvatar configWithTeam:team];
	
	_collectionViewMembersHeighConstraint.constant = team.followers.count > 0 ? 25 : 0;
	[self.collectionViewMembers reloadData];
}

- (void)configWithEvent:(BSEventMO *)event {
	_event = event;
	_users = _event.followersSortedByAlphabet;
	_isTeamData = NO;
	
	_lblTitle.text = ZPLocalizedString(@"RECOMMENDED EVENT");
	[self _formatDescriptionWithText:event.recommend_description];
	[_imgViewCover sd_setImageWithURL:[NSURL URLWithString:event.cover_url]];
	[_btnName setTitle:event.name.uppercaseString forState:UIControlStateNormal];
	[_btnAvatar configWithEvent:event];
	_btnAvatar.customTappedAction = ^ {
		[self btnNameTapped:nil];
	};
	
	_collectionViewMembersHeighConstraint.constant = event.followers.count > 0 ? 25 : 0;
	[self.collectionViewMembers reloadData];
}

- (void)configWithDataModel:(id)dataModel {
	if ([dataModel isKindOfClass:[BSTeamMO class]]) {
		[self configWithTeam:dataModel];
	} else if ([dataModel isKindOfClass:[BSEventMO class]]) {
		[self configWithEvent:dataModel];
	}
}

- (void)_sendServerForUserAction {
	if (_isTeamData) {
		BSTeamCloseFromTimelineHttpRequest *request = [BSTeamCloseFromTimelineHttpRequest request];
		request.teamId = _team.identifierValue;
		[request postRequestWithSucceedBlock:NULL failedBlock:NULL];
	} else {
		BSEventCloseFromTimelineHttpRequest *request = [BSEventCloseFromTimelineHttpRequest request];
		request.eventId = _event.identifierValue;
		[request postRequestWithSucceedBlock:NULL failedBlock:NULL];
	}
}

- (IBAction)btnCloseTapped:(id)sender {
	if ([_delegate respondsToSelector:@selector(feedRecommendCell:didTapCloseButton:)]) {
		[_delegate feedRecommendCell:self didTapCloseButton:sender];
		
		[self _sendServerForUserAction];
		[BSEventTracker trackTap:@"close_guide" page:nil properties:@{@"guide":(_isTeamData ? @"recommended_team" : @"recommended_event")}];
	}
}

- (IBAction)btnNameTapped:(id)sender {
	[BSEventTracker trackTap:@"open_guide" page:nil properties:@{@"guide":(_isTeamData ? @"recommended_team" : @"recommended_event")}];
	[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithModel:_isTeamData ? _team : _event]];
	
	[self _sendServerForUserAction];
}

- (BSUserMO *)_getUserAtIndexPath:(NSIndexPath *)indexPath {
	BSUserMO *user = _users[indexPath.row];
	
	return user;
}

#pragma mark TTTAttributeLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
	[BSEventTracker trackTap:@"open_guide" page:nil properties:@{@"guide":(_isTeamData ? @"recommended_team" : @"recommended_event"), @"action":@"follow"}];

	BSProfileViewController *vc = [BSProfileViewController instanceFromStoryboardWithModel:_isTeamData ? _team : _event];
	[vc view];
	[BSUtility pushViewController:vc];
	if (!_isTeamData && !_event.is_followingValue) {
		[vc.btnSettingOrFollow sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
	
	[self _sendServerForUserAction];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger count = _users.count;
	if (count > 4) {
		count = 4;
	}
	return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	BSProfileAvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSProfileAvatarCollectionViewCell.className forIndexPath:indexPath];
	
	[cell.btnAvatar configWithUser:[self _getUserAtIndexPath:indexPath]];
	
	return cell;
}

@end
