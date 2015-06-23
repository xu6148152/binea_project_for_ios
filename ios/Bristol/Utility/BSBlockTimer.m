//
//  BSBlockTimer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBlockTimer.h"

@interface BSBlockTimer()
{
    NSTimer *_tmr;
	NSDate *_lastTickDate;
    NSTimeInterval _step, _interval;
    ZPFloatBlock _tickBlock;
}

@end

@implementation BSBlockTimer

- (void)startWithInterval:(NSTimeInterval)ti tickBlock:(ZPFloatBlock)tickBlock {
    _tickBlock = tickBlock;
    
    if (!_tmr) {
        dispatch_main_async_safe(^{
			_interval = ti;
            _tmr = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(_tick) userInfo:nil repeats:YES];
        });
    }
}

- (void)_tick {
	_lastTickDate = [NSDate date];
	
    _step += _interval;
    ZPInvokeBlock(_tickBlock, _step);
}

- (void)pause {
	if (_tmr) {
		[_tmr invalidate];
		_tmr = nil;
		
		NSDate *now = [NSDate date];
		NSTimeInterval interval = [now timeIntervalSinceDate:_lastTickDate];
		_step += interval;
		ZPLogDebug(@"_step: %.2f", _step);
	}
}

- (void)resetStep {
    _step = 0;
}

@end
