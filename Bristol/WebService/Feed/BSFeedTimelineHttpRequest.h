//
//  BSFeedTimelineHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSFeedTimelineHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType olderThanHighlightId;
@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) NSUInteger countInOnePage; // defaults to kDataCountInOnePage
@property (nonatomic, assign) CLLocationDegrees latitude; // defaults to 400
@property (nonatomic, assign) CLLocationDegrees longitude; // defaults to 400
@property (nonatomic, assign) BOOL show_create_team_notification;

@end
