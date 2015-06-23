//
//  BSAvatarButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAvatarButton.h"
#import "BSUserMO.h"
#import "BSProfileViewController.h"
#import "BSUtility.h"

#import "UIButton+WebCache.h"
#import "UIControl+EventTrack.h"

@interface BSAvatarButton ()

@property (nonatomic, strong) id data;
@property (nonatomic) BOOL disableRoundedCorner;
@end

@implementation BSAvatarButton

- (void)_commitInit {
    self.clipsToBounds = YES;
	[self addTarget:self action:@selector(_tapped) forControlEvents:UIControlEventTouchUpInside];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_avatarDidChanged) name:kAvatarDidUpdatedNotification object:nil];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[self _commitInit];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	if (self.disableRoundedCorner) {
		self.layer.cornerRadius = 0;
	} else {
		CGFloat cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
		if (self.superview) {
			cornerRadius = MIN(cornerRadius, MIN(self.superview.width, self.superview.height) / 2);
		}
		self.layer.cornerRadius = cornerRadius;
	}
}

- (void)_avatarDidChanged {
	if ([_data isKindOfClass:[BSUserMO class]]) {
		[self configWithUser:_data];
	} else if ([_data isKindOfClass:[BSTeamMO class]]) {
		[self configWithTeam:_data];
	} else {
		[self configWithEvent:_data];
	}
}

- (void)_tapped {
	if (_customTappedAction) {
		ZPInvokeBlock(_customTappedAction);
	} else {
		[BSUtility pushViewController:[BSProfileViewController instanceFromStoryboardWithModel:_data]];
	}
}

- (void)_setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		[self sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:placeholder]];
	});
}

- (void)configWithUser:(BSUserMO *)user {
	_data = user;
	
	self.disableRoundedCorner = NO;
	[self setNeedsLayout];
	[self _setImageWithURL:user.avatar_url placeholder:@"common_userdefaultportrait_big"];
}

- (void)configWithTeam:(BSTeamMO *)team {
	_data = team;
	
	self.disableRoundedCorner = YES;
	[self setNeedsLayout];
	[self _setImageWithURL:team.avatar_url placeholder:@"common_teamdefaulticon_small"];
}

- (void)configWithEvent:(BSEventMO *)event {
	_data = event;
	
	[self setImage:[UIImage imageNamed:@"profile_portrait_event"] forState:UIControlStateNormal];
}

#pragma mark - event tracking
- (NSString *) eventTrackName {
	if ([_data isKindOfClass:[BSUserMO class]]) {
		return @"user";
	} else if ([_data isKindOfClass:[BSTeamMO class]]) {
		return @"team";
	} else if ([_data isKindOfClass:[BSEventMO class]]){
		return @"event";
	} else {
		return nil;
	}
}

- (NSDictionary *) eventTrackProperties {
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:[super eventTrackProperties]];
	
	if ([_data isKindOfClass:[BSUserMO class]]) {
		[properties setObject:((BSUserMO*)_data).identifier forKey:@"user_id"];
		[properties setObject:((BSUserMO*)_data).is_following ? @"yes":@"no" forKey:@"following"];
	} else if ([_data isKindOfClass:[BSTeamMO class]]) {
		[properties setObject:((BSTeamMO*)_data).identifier forKey:@"team_id"];
		[properties setObject:((BSTeamMO*)_data).members_count forKey:@"team_members"];
	} else if ([_data isKindOfClass:[BSEventMO class]]){
		[properties setObject:((BSEventMO*)_data).identifier forKey:@"event_id"];
		[properties setObject:@(((BSEventMO*)_data).followers.count) forKey:@"event_friends"];
	}
	
	return properties;
}
@end
