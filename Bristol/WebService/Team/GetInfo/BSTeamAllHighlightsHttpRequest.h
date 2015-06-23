//
//  BSTeamAllHighlightsHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamBaseHttpRequest.h"

@interface BSTeamAllHighlightsHttpRequest : BSTeamBaseHttpRequest

@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) NSUInteger countInOnePage; // defaults to kDataCountInOnePage

@end
