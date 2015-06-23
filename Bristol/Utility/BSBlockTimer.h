//
//  BSBlockTimer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBlockTimer : NSObject

- (void)startWithInterval:(NSTimeInterval)ti tickBlock:(ZPFloatBlock)tickBlock;
- (void)pause;
- (void)resetStep;

@end
