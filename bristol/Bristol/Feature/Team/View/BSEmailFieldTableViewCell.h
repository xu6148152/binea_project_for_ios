//
//  BSEmailFieldTableViewCell.h
//  Bristol
//
//  Created by Yangfan Huang on 3/9/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"

@protocol BSEmailFieldTableViewCellDelegate <NSObject>
- (void) rowDidBeginEditing:(NSInteger)row;
- (void) row:(NSInteger)row didInputEmail:(NSString *)email;
@end

@interface BSEmailFieldTableViewCell : BSBaseTableViewCell

@property (nonatomic, weak) id<BSEmailFieldTableViewCellDelegate> delegate;

- (void) configureRow:(NSUInteger)row email:(NSString *)email;
- (void) beginEditing;
@end
