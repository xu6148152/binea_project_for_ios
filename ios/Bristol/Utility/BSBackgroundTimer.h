//
//  BSBackgroundTimer.h
//  Bristol
//
//  Created by Gary Wong on 1/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BSBackgroundTimerTick)(NSUInteger);
typedef void (^BSBackgroundTimerCompletion)();

@interface BSBackgroundTimer : NSObject

+ (BSBackgroundTimer *)timerWithTickCount:(NSUInteger)tickCount totalDuration:(NSTimeInterval)duration queue:(dispatch_queue_t)queue atEachTickDo:(BSBackgroundTimerTick)eachTickBlock completion:(BSBackgroundTimerCompletion)completionBlock;

- (void)run;
- (void)cancel;

@end
