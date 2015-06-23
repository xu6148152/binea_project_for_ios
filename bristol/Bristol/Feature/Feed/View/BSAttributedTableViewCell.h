//
//  BSAttributedTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "BSAttributedLabel.h"

@interface BSAttributedTableViewCell : BSBaseTableViewCell

- (void)configAttributedLabel:(BSAttributedLabel *)commentLabel text:(NSString *)text commenter:(NSString *)commenter;

@end
