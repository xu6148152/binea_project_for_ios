//
//  BSBasePickerTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseTableViewCell.h"
#import "BSSoundButton.h"

@interface BSBasePickerTableViewCell : BSBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet BSSoundButton *btnSound;

@property (assign, nonatomic) BOOL showIcon;
@property (assign, nonatomic) BOOL showSoundButton;

- (void)setIsHighlight:(BOOL)highlight;

@end
