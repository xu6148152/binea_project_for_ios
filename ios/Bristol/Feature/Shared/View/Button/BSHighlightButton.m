//
//  BSHighlightButton.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightButton.h"
#import "BSFeedViewController.h"
#import "BSFeedCommentsViewController.h"

#import "UIButton+WebCache.h"
#import "UIControl+EventTrack.h"

@interface BSHighlightButton()
{
	
}
@property(nonatomic, strong) BSHighlightMO *highlight;
@property(nonatomic, strong) BSNotificationMO *notification;

@end

@implementation BSHighlightButton

- (void)_commitInit {
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addTarget:self action:@selector(_tapped) forControlEvents:UIControlEventTouchUpInside];
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

- (void)_tapped {
	UIViewController *pushingViewController = [BSUtility getTopmostViewController];
	if (pushingViewController && self.highlight) {
		BSFeedViewController *vc = [BSFeedViewController instanceWithHighlight:self.highlight notification:self.notification];
		if (pushingViewController.navigationController) {
			[pushingViewController.navigationController pushViewController:vc animated:YES];
		}
		else {
			[pushingViewController presentViewController:vc animated:YES completion:NULL];
		}
	}
}

- (void)_configWithHighlight:(BSHighlightMO *)highlight notification:(BSNotificationMO *)notification completion:(ZPImageBlock)completion {
	self.highlight = highlight;
	self.enabled = self.highlight != nil;
	self.notification = notification;
	[self sd_setImageWithURL:[NSURL URLWithString:highlight.cover_url] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		ZPInvokeBlock(completion, image);
	}];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight completion:(ZPImageBlock)completion {
	[self _configWithHighlight:highlight notification:nil completion:completion];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight {
	[self _configWithHighlight:highlight notification:nil completion:nil];
}

- (void)configWithHighlight:(BSHighlightMO *)highlight notification:(BSNotificationMO *)notification {
	[self _configWithHighlight:highlight notification:notification completion:nil];
}

#pragma mark - event tracking
- (NSString *) eventTrackName {
	return @"video";
}

- (NSDictionary *)eventTrackProperties {
	NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:[super eventTrackProperties]];
	[properties setObject:self.highlight.identifier forKey:@"video_id"];
	return properties;
}
@end