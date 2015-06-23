//
//  BSSoundButton.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSongDataModel.h"

@interface BSSoundButton : UIButton

- (void)configWithSong:(BSSongDataModel *)song;

@end
