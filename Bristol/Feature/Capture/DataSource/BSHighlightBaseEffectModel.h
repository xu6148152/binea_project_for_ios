//
//  BSHighlightBaseEffectModel.h
//  Bristol
//
//  Created by Gary Wong on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSEffectBaseCompositionLayer.h"
#import "BSBaseVideoCompositor.h"
#import "BSCoreImageManager.h"

#import "THVideoItem.h"
#import "THAudioItem.h"
#import "THVolumeAutomation.h"

@interface BSHighlightBaseEffectModel : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *iconNormal;
@property (nonatomic, strong, readonly) NSString *iconHighlight;
@property (nonatomic, strong, readonly) NSURL *audioUrl;
@property (nonatomic, strong, readonly) BSEffectBaseCompositionLayer *compositionLayer;
@property (nonatomic, strong, readonly) Class videoCompositorClass;

@property (nonatomic, strong) THVideoItem *videoItemDefault;
@property (nonatomic, strong) THAudioItem *audioItemDefault;
@property (nonatomic, strong) THVolumeAutomation *audioItemDefaultFadeOutAutomation;
@property (nonatomic, strong, readonly) NSArray *videoItems; // list of THVideoItem objects
@property (nonatomic, strong, readonly) NSArray *musicItems; // list of THAudioItem objects
@property (nonatomic, strong, readonly) NSArray *titleItems; // list of THCompositionLayer objects
@property (nonatomic, assign, readonly) BSCoreImageFilter filterType; // defaults to BSCoreImageFilterNone

+ (instancetype)highlightEffectModelWithName:(NSString *)name iconNormal:(NSString *)iconNormal iconHighlight:(NSString *)iconHighlight audioUrl:(NSURL *)audioUrl compositionLayerClass:(Class)compositionLayerClass videoCompositorClass:(Class)videoCompositorClass;
- (id)initWithName:(NSString *)name iconNormal:(NSString *)iconNormal iconHighlight:(NSString *)iconHighlight audioUrl:(NSURL *)audioUrl compositionLayerClass:(Class)compositionLayerClass videoCompositorClass:(Class)videoCompositorClass;

- (void)updateAudioWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion;

// overwrite required
@property (nonatomic, assign, readonly) NSTimeInterval requiredVideoDuration;
- (void)updateVideoWithVideoItem:(THVideoItem *)videoItem;
- (void)updateVideoWithUrl:(NSURL *)url completion:(ZPVoidBlock)completion;
- (void)didChangedSelectedBeginTime:(NSTimeInterval)selectedBeginTime selectedEndTime:(NSTimeInterval)selectedEndTime selectedHighlightTime:(NSTimeInterval)selectedHighlightTime inputVideoDuration:(NSTimeInterval)inputVideoDuration;

@end
