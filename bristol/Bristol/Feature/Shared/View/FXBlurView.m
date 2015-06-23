//
//  FXBlurView.m
//
//  Version 1.6.3
//
//  Created by Nick Lockwood on 25/08/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXBlurView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import "FXBlurView.h"
#import <objc/runtime.h>


#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
#pragma GCC diagnostic ignored "-Wgnu"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BSCoreImageManager.h"


@interface FXBlurScheduler : NSObject

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) NSUInteger viewIndex;
@property (nonatomic, assign) NSUInteger updatesEnabled;
@property (nonatomic, assign) BOOL updating;

@end


@interface FXBlurLayer: CALayer

@property (nonatomic, assign) CGFloat blurRadius;

@end


@implementation FXBlurLayer

@dynamic blurRadius;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([@[@"bounds", @"position"] containsObject:key])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end


@interface FXBlurView ()
{
    UIPanGestureRecognizer *_panGesture;
    CGAffineTransform _transform;
}

@property (nonatomic, assign) BOOL iterationsSet;
@property (nonatomic, assign) BOOL dynamicSet;
@property (nonatomic, assign) BOOL isAppActive;
@property (nonatomic, strong) NSDate *lastUpdate;

- (UIImage *)snapshotOfUnderlyingView;
- (BOOL)shouldUpdate;

@end


@implementation FXBlurScheduler

+ (instancetype)sharedInstance
{
    static FXBlurScheduler *sharedInstance = nil;
    if (!sharedInstance)
    {
        sharedInstance = [[FXBlurScheduler alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        _updatesEnabled = 1;
        _views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setUpdatesEnabled
{
    _updatesEnabled ++;
    [self updateAsynchronously];
}

- (void)setUpdatesDisabled
{
    _updatesEnabled --;
}

- (void)addView:(FXBlurView *)view
{
    if (![self.views containsObject:view])
    {
        [self.views addObject:view];
        [self updateAsynchronously];
    }
}

- (void)removeView:(FXBlurView *)view
{
    NSUInteger index = [self.views indexOfObject:view];
    if (index != NSNotFound)
    {
        if (index <= self.viewIndex)
        {
            self.viewIndex --;
        }
        [self.views removeObjectAtIndex:index];
    }
}

- (void)updateAsynchronously
{
    if (!self.updating && self.updatesEnabled > 0 && [self.views count])
    {
        NSTimeInterval timeUntilNextUpdate = 1.0 / 60;
        
        //loop through until we find a view that's ready to be drawn
        self.viewIndex = self.viewIndex % [self.views count];
        for (NSUInteger i = self.viewIndex; i < [self.views count]; i++)
        {
            FXBlurView *view = self.views[i];
            if (view.dynamic && !view.hidden && view.window && [view shouldUpdate])
            {
                NSTimeInterval nextUpdate = [view.lastUpdate timeIntervalSinceNow] + view.updateInterval;
                if (!view.lastUpdate || nextUpdate <= 0)
                {
                    self.updating = YES;
                    [view updateAsynchronously:YES completion:^{
                        
                        //render next view
                        self.updating = NO;
                        self.viewIndex = i + 1;
                        [self updateAsynchronously];
                    }];
                    return;
                }
                else
                {
                    timeUntilNextUpdate = MIN(timeUntilNextUpdate, nextUpdate);
                }
            }
        }

        //try again, delaying until the time when the next view needs an update.
        self.viewIndex = 0;
        [self performSelector:@selector(updateAsynchronously)
                   withObject:nil
                   afterDelay:timeUntilNextUpdate
                      inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }
}

@end


@implementation FXBlurView

+ (void)setUpdatesEnabled
{
    [[FXBlurScheduler sharedInstance] setUpdatesEnabled];
}

+ (void)setUpdatesDisabled
{
    [[FXBlurScheduler sharedInstance] setUpdatesDisabled];
}

+ (Class)layerClass
{
    return [FXBlurLayer class];
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    
    if (!_iterationsSet) _iterations = 3;
    if (!_dynamicSet) _dynamic = NO;
    self.updateInterval = _updateInterval;
	self.layer.magnificationFilter = @"linear"; // kCAFilterLinear
	
	_isAppActive = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_applicationWillResignActive {
	_isAppActive = NO;
}

- (void)_applicationDidBecomeActive {
	_isAppActive = YES;
}

- (void)setIterations:(NSUInteger)iterations
{
    _iterationsSet = YES;
    _iterations = iterations;
    [self setNeedsDisplay];
}

- (void)setMoveEnabled:(BOOL)moveEnabled {
    if (_moveEnabled != moveEnabled) {
        _moveEnabled = moveEnabled;
        
        if (moveEnabled) {
            _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_didPan:)];
            [self addGestureRecognizer:_panGesture];
        } else {
            [self removeGestureRecognizer:_panGesture];
        }
    }
}

- (void)setDynamic:(BOOL)dynamic
{
    _dynamicSet = YES;
    if (_dynamic != dynamic)
    {
        _dynamic = dynamic;
        [self schedule];
        if (!dynamic)
        {
            [self setNeedsDisplay];
        }
    }
}

- (FXBlurLayer *)blurLayer
{
    return (FXBlurLayer *)self.layer;
}

- (FXBlurLayer *)blurPresentationLayer
{
    FXBlurLayer *blurLayer = [self blurLayer];
    return (FXBlurLayer *)blurLayer.presentationLayer ?: blurLayer;
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval
{
    _updateInterval = updateInterval;
    if (_updateInterval <= 0) _updateInterval = 1.0/60;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.layer setNeedsDisplay];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self schedule];
}

- (void)schedule
{
    if (self.window && self.dynamic)
    {
        [[FXBlurScheduler sharedInstance] addView:self];
    }
    else
    {
        [[FXBlurScheduler sharedInstance] removeView:self];
    }
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

- (BOOL)shouldUpdate
{
    __strong CALayer *windowLayer = self.window.layer;
    
    return
    _isAppActive && windowLayer && !windowLayer.hidden &&
    !CGRectIsEmpty([self.layer.presentationLayer ?: self.layer bounds]) && !CGRectIsEmpty(windowLayer.bounds);
}

- (void)displayLayer:(__unused CALayer *)layer
{
    [self updateAsynchronously:NO completion:NULL];
}

- (UIImage *)snapshotOfUnderlyingView
{
    __strong FXBlurLayer *blurLayer = [self blurPresentationLayer];
    __strong CALayer *windowLayer = self.window.layer;
    CGRect bounds = [blurLayer convertRect:blurLayer.bounds toLayer:windowLayer];
    
    self.lastUpdate = [NSDate date];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -bounds.origin.x, -bounds.origin.y);
	
	BOOL originHidden = self.layer.hidden;
	self.layer.hidden = YES;
	[windowLayer renderInContext:context];
	self.layer.hidden = originHidden;
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (void)setLayerContents:(UIImage *)image
{
    self.layer.contents = (id)image.CGImage;
    self.layer.contentsScale = image.scale;
}

- (void)updateAsynchronously:(BOOL)async completion:(void (^)())completion
{
    if ([self shouldUpdate])
    {
        UIImage *snapshot = [self snapshotOfUnderlyingView];
        if (async)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *blurredImage = [[BSCoreImageManager sharedManager] multiplyBlendImage:snapshot];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self setLayerContents:blurredImage];
                    if (completion) completion();
                });
            });
        }
        else
        {
            UIImage *blurredImage = [[BSCoreImageManager sharedManager] multiplyBlendImage:snapshot];
            [self setLayerContents:blurredImage];
            if (completion) completion();
        }
    }
    else if (completion)
    {
        completion();
    }
}

#pragma mark - gesture
- (void)_didPan:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _transform = self.transform;
            break;
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint translation = [panGesture translationInView:self];
            self.transform = CGAffineTransformTranslate(_transform, translation.x, translation.y);

            [self setNeedsDisplay];
            break;
        }
        default:
            break;
    }
}

@end
