//
//  BSVideoTrimmerThumbnailCollectionViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSVideoTrimmerThumbnailCollectionViewCell.h"

@interface BSVideoTrimmerThumbnailCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation BSVideoTrimmerThumbnailCollectionViewCell

- (void)prepareForReuse {
	[super prepareForReuse];
	
	_imageView.image = nil;
}

- (void)setThumbnail:(UIImage *)thumbnail showMask:(BOOL)showMask {
	_imageView.image = thumbnail;
	_maskView.hidden = !showMask;
}

@end
