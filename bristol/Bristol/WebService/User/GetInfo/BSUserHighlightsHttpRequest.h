//
//  BSUserHighlightsHttpRequest.h
//  Bristol
//
//  Created by Bo on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSUserBaseHttpRequest.h"

@interface BSUserHighlightsHttpRequest : BSUserBaseHttpRequest

@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, assign) NSUInteger countInOnePage; // defaults to kDataCountInOnePage

@end
