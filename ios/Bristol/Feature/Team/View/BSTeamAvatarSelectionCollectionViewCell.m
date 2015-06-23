//
//  BSTeamAvatarSelectionCollectionViewCell.m
//  Bristol
//
//  Created by Yangfan Huang on 3/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAvatarSelectionCollectionViewCell.h"

@interface BSTeamAvatarSelectionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@end

@implementation BSTeamAvatarSelectionCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setAvatarSelected:(BOOL) selected {
	self.selectedBtn.hidden = !selected;
}

- (void) configureAvatarImage:(UIImage *)image {
	self.avatarImgView.image = image;
}

- (void) configureAvatarUrl:(NSString *)url {
	[self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

@end
