//
//  UIButton+EventName.h
//  Bristol
//
//  Created by Yangfan Huang on 5/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIControl (EventTrack)
@property (nonatomic) NSString *eventTrackName;
@property (nonatomic) NSDictionary *eventTrackProperties;

- (void) trackTap;
@end

@interface UIBarButtonItem (EventTrack)
@property (nonatomic) NSString *eventTrackName;
@property (nonatomic) NSDictionary *eventTrackProperties;

- (void) trackTap;
@end