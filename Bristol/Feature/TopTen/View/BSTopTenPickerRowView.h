//
//  BSTopTenPickerRowView.h
//  Bristol
//
//  Created by Bo on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSEventMO.h"
#import "BSSportMO.h"

@interface BSTopTenPickerRowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *channelLbl;
@property (nonatomic, strong) BSEventMO *event;
@property (nonatomic, strong) BSSportMO *sport;

- (void)configWithEvent:(BSEventMO *)event;
- (void)configWithSport:(BSSportMO *)sport;
- (void)setTextForChannelLabel:(NSString *)channelStr;

@end
