//
//  BSTopTenPickerRowView.m
//  Bristol
//
//  Created by Bo on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenPickerRowView.h"

@implementation BSTopTenPickerRowView

- (void)configWithEvent:(BSEventMO *)event {
    self.event = event;
    self.sport = nil;
    [self setTextForChannelLabel:event.name];
}

- (void)configWithSport:(BSSportMO *)sport {
    self.sport = sport;
    self.event = nil;
    [self setTextForChannelLabel:sport.nameLocalized];
}

- (void)setTextForChannelLabel:(NSString *)channelStr {
    [self.channelLbl setText:channelStr.uppercaseString];
}

@end
