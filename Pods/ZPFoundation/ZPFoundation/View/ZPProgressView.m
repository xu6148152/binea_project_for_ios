//
//  ZPProgressView.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/9/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPProgressView.h"

@implementation ZPProgressView
{
	NSTimer *_tmr;
	CGFloat _progressDelta, _progressTarget;
	ZPVoidBlock _completeBlock;
}
static const CGFloat FPS = 40;

- (void)_commitInit {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;

	_progress = 0;
	_lineWidth = 5;
	_backgroundTintColor = [UIColor colorWithWhite:1 alpha:.1];
	_progressTintColor = [UIColor whiteColor];

	[self _registerForKVO];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _commitInit];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[self _commitInit];
}

- (void)dealloc {
	[self _unregisterFromKVO];
}

- (void)drawRect:(CGRect)rect {
	UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
	processBackgroundPath.lineWidth = _lineWidth;
	processBackgroundPath.lineCapStyle = kCGLineCapRound;
	CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
	CGFloat radius = (self.bounds.size.width - _lineWidth) / 2;
	CGFloat startAngle = -((float)M_PI / 2);
	CGFloat endAngle = (2 * (float)M_PI) + startAngle;
	[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
	[_backgroundTintColor set];
	[processBackgroundPath stroke];

	UIBezierPath *processPath = [UIBezierPath bezierPath];
	processPath.lineCapStyle = kCGLineCapRound;
	processPath.lineWidth = _lineWidth;
	endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
	[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
	[_progressTintColor set];
	[processPath stroke];
}

- (void)_invalidTimer {
	[_tmr invalidate];
	_tmr = nil;
}

- (void)_timerTick {
	self.progress += _progressDelta;
	if (self.progress >= _progressTarget) {
		self.progress = _progressTarget;
		[self _invalidTimer];
		ZPInvokeBlock(_completeBlock);
	}
}

- (void)setProgress:(CGFloat)progress animationDuration:(CGFloat)duration completeBlock:(ZPVoidBlock)completeBlock {
	duration = fabsf(duration);
	[self _invalidTimer];

	if (duration > 0) {
		_progressTarget = progress;
		_progressDelta = (progress - self.progress) / (FPS * duration);
		_completeBlock = completeBlock;

		_tmr = [NSTimer scheduledTimerWithTimeInterval:1. / FPS target:self selector:@selector(_timerTick) userInfo:nil repeats:YES];
	}
	else {
		self.progress = progress;
	}
}

- (void)cancelAnimation {
	if (_tmr) {
		[self _invalidTimer];
		self.progress = _progressTarget;
		_completeBlock = nil;
	}
}

#pragma mark - KVO
- (void)_registerForKVO {
	for (NSString *keyPath in[self _observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)_unregisterFromKVO {
	for (NSString *keyPath in[self _observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)_observableKeypaths {
	return @[@"progress", @"lineWidth", @"backgroundTintColor", @"progressTintColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setNeedsDisplay];
}

@end
