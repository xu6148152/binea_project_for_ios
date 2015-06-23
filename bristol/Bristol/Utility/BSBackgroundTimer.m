//
//  BSBackgroundTimer.m
//  Bristol
//
//  Created by Gary Wong on 1/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBackgroundTimer.h"

@interface BSBackgroundTimer(){
    dispatch_source_t _timer;
    NSUInteger _index;
}

@property (nonatomic) NSUInteger numberOfTicks;
@property (nonatomic) NSTimeInterval totalDuration;
@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic, copy) BSBackgroundTimerTick eachTickBlock;
@property (nonatomic, copy) BSBackgroundTimerCompletion completionBlock;

@end

@implementation BSBackgroundTimer

- (id)initWithTickCount:(NSUInteger)tickCount totalDuration:(NSTimeInterval)duration queue:(dispatch_queue_t)queue atEachTickDo:(BSBackgroundTimerTick)eachTickBlock completion:(BSBackgroundTimerCompletion)completionBlock {
    self = [super init];
    if (self) {
		NSParameterAssert(tickCount != 0);
        self.numberOfTicks = tickCount;
        self.totalDuration = duration;
        self.queue = queue;
        self.eachTickBlock = eachTickBlock;
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)run {
    _index = 0;
    _timer = CreateDispatchTimer(1ull * NSEC_PER_SEC * (self.totalDuration/self.numberOfTicks), (1ull * NSEC_PER_SEC), self.queue, ^{
        [self _tick];
    });
}

- (void)cancel {
    dispatch_source_cancel(_timer);
}

- (void)_tick {
    if (_index >= (self.numberOfTicks - 1)) {
		[self cancel];
		ZPInvokeBlock(self.eachTickBlock, _index);
		dispatch_main_async_safe(^{
			ZPInvokeBlock(self.completionBlock);
		});
    } else {
        ZPInvokeBlock(self.eachTickBlock, _index);
	}
	_index++;
}

+ (BSBackgroundTimer *)timerWithTickCount:(NSUInteger)tickCount totalDuration:(NSTimeInterval)duration queue:(dispatch_queue_t)queue atEachTickDo:(BSBackgroundTimerTick)eachTickBlock completion:(BSBackgroundTimerCompletion)completionBlock {
    return [[self alloc] initWithTickCount:tickCount totalDuration:duration queue:queue atEachTickDo:eachTickBlock completion:completionBlock];
}

// see: https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html#//apple_ref/doc/uid/TP40008091-CH103-SW2
dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

@end
