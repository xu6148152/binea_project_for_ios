//
//  BSProfileTeamTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileTeamTableViewCell.h"
#import "BSProfileAvatarCollectionViewCell.h"
#import "BSProfileHighlightCollectionViewCell.h"

#import "BSFeedViewController.h"

#import "BSTeamFollowHttpRequest.h"
#import "BSEventFollowHttpRequest.h"

#import "UIControl+EventTrack.h"

@interface BSProfileTeamTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	BSTeamMO *_team;
	BSEventMO *_event;
	BOOL _isTeamData;
	NSArray *_highlights;
	NSArray *_users;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMembers;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewHighlights;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadingConstraint;
@end


@implementation BSProfileTeamTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[_collectionViewHighlights registerNib:[UINib nibWithNibName:BSProfileHighlightCollectionViewCell.className bundle:nil] forCellWithReuseIdentifier:BSProfileHighlightCollectionViewCell.className];
	[_collectionViewMembers registerNib:[UINib nibWithNibName:BSProfileAvatarCollectionViewCell.className bundle:nil] forCellWithReuseIdentifier:BSProfileAvatarCollectionViewCell.className];
}

- (void)configWithTeam:(BSTeamMO *)team {
	if (_isTeamData && _team == team) {
		return;
	}

	_isTeamData = YES;
	_team = team;
	_event = nil;
	_users = _team.membersSortedByAlphabet;
	
	[_btnFollow configWithTeam:_team];
	_btnFollow.eventTrackProperties = self.eventTrackProperties;
	_imgViewAvatar.hidden = NO;
    [_imgViewAvatar sd_setImageWithURL:[NSURL URLWithString:_team.avatar_url] placeholderImage:[UIImage imageNamed:@"common_teamdefaulticon_small"]];
	_lblName.text = _team.name.uppercaseString;
	_nameLeadingConstraint.constant = 16 + _imgViewAvatar.width;
	_lblDescription.text = [NSString stringWithFormat:ZPLocalizedString(@"%d member(s)"), _users.count];
	if (_team.highlights && _team.highlights.count > 0) {
		_highlights = [_team.highlights sortedArrayWithKey:@"created_at" ascending:NO];
	} else {
		_highlights = [_team.recent_highlights sortedArrayWithKey:@"created_at" ascending:NO];
	}

	[self.collectionViewMembers reloadData];
	[self.collectionViewHighlights reloadData];
}

- (void)configWithEvent:(BSEventMO *)event {
	if (!_isTeamData && _event == event) {
		return;
	}

	_isTeamData = NO;
	_event = event;
	_team = nil;
	_users = _event.recent_followersSortedByAlphabet;

	[_btnFollow configWithEvent:event];
	_btnFollow.eventTrackProperties = self.eventTrackProperties;
	_imgViewAvatar.hidden = YES;
	_lblName.text = _event.name.uppercaseString;
	_nameLeadingConstraint.constant = 8;
	_lblDescription.text = [self _getEventFriendsDescription];
	
	if (_event.highlights && _event.highlights.count > 0) {
		_highlights = [_event.highlights sortedArrayWithKey:@"created_at" ascending:NO];
	} else {
		_highlights = [_event.recent_highlights sortedArrayWithKey:@"created_at" ascending:NO];
	}
	
	[self.collectionViewMembers reloadData];
	[self.collectionViewHighlights reloadData];
}

- (void)configWithData:(id)data {
	if ([data isKindOfClass:[BSTeamMO class]]) {
		[self configWithTeam:data];
	} else if ([data isKindOfClass:[BSEventMO class]]) {
		[self configWithEvent:data];
	}
}

- (NSString *)_getEventFriendsDescription {
	if (_users.count == 0) {
		return @"";
	}
	
	NSString *description = ((BSUserMO *)_users[0]).name_id;
	if (!description) {
		description = @"";
	}
	
	if (_users.count > 1) {
		if (((BSUserMO *)_users[1]).name_id) {
			description = [[description stringByAppendingString:@", "] stringByAppendingString:((BSUserMO *)_users[1]).name_id];
		}
	}
	if (_users.count > 2) {
		description = [description stringByAppendingString:[NSString stringWithFormat:ZPLocalizedString(@" and %d other friend(s)"), _users.count - 2]];
	}
	return description;
}

- (BSUserMO *)_getUserAtIndexPath:(NSIndexPath *)indexPath {
	BSUserMO *user;
	if (_isTeamData) {
		user = _users[indexPath.row];
	}
	else {
		user = _users[indexPath.row];
	}

	return user;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSInteger count = 0;
	if (collectionView == _collectionViewMembers) {
		count = _users.count;
		if (count > 4) {
			count = 4;
		}
	}
	else {
		return kHighlightCellColumnCount;
	}
	return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == _collectionViewMembers) {
		BSProfileAvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSProfileAvatarCollectionViewCell.className forIndexPath:indexPath];

		[cell.btnAvatar configWithUser:[self _getUserAtIndexPath:indexPath]];

		return cell;
	}
	else {
		BSProfileHighlightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSProfileHighlightCollectionViewCell.className forIndexPath:indexPath];

		if (indexPath.row < _highlights.count) {
			[cell.btnHighlight configWithHighlight:_highlights[indexPath.row]];
			cell.btnHighlight.eventTrackProperties = self.eventTrackProperties;
		} else {
			[cell.btnHighlight configWithHighlight:nil];
		}

		return cell;
	}
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == _collectionViewMembers) {
	}
	else {
		if (indexPath.row < _highlights.count) {
			[BSUtility pushViewController:[BSFeedViewController instanceWithHighlight:_highlights[indexPath.row]]];
		}
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (collectionView == _collectionViewMembers) {
		return CGSizeMake(25, 25);
	}
	else {
		float length = (self.width - (kHighlightCellColumnCount - 1)) / kHighlightCellColumnCount;
		return CGSizeMake(length, length);
	}
}

#pragma mark - event tracking
- (NSDictionary *) eventTrackProperties {
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:_eventTrackProperties];
	
	if (_isTeamData) {
		[properties setObject:_team.identifier forKey:@"team_id"];
		[properties setObject:_team.members_count forKey:@"team_members"];
	} else {
		[properties setObject:_event.identifier forKey:@"event_id"];
		[properties setObject:@(_event.followers.count) forKey:@"event_friends"];
	}
	
	return properties;
}
@end
