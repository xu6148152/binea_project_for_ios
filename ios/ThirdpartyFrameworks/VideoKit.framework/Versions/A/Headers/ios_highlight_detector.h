//
//  ios_highlight_detector.h
//  VideoKit
//
//  Created by Jack Yang on 2/8/15.
//  Copyright (c) 2015 Zepp Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class vkhighlight;

@interface  VkHighlight : NSObject

@property (nonatomic, assign) int beginTimeMs;
@property (nonatomic, assign) int endTimeMs;

@end

@class VkHighlightDetector;

@interface VkHighlightDetector : NSObject

- (NSArray*)detectHighlights:(NSURL*)fileUrl expectedOutputHighlightsNumber:(int)highlightsNumber;

@end
