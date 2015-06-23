//
//  BSTeamAvatarSelectionCollectionViewCell.h
//  Bristol
//
//  Created by Yangfan Huang on 3/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseCollectionViewCell.h"

@interface BSTeamAvatarSelectionCollectionViewCell : BSBaseCollectionViewCell

- (void) setAvatarSelected:(BOOL) selected;
- (void) configureAvatarImage:(UIImage *)image;
- (void) configureAvatarUrl:(NSString *)url;
@end
