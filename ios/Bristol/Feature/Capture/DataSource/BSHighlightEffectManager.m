//
//  BSHighlightEffectManager.m
//  Bristol
//
//  Created by Gary Wong on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightEffectManager.h"
#import "BSEffectCompositionLayer1.h"
#import "BSEffectCompositionLayer2.h"
#import "BSEffectVideoCompositor1.h"
#import "BSEffectVideoCompositor2.h"

@implementation BSHighlightEffectManager

static BSHighlightEffectManager *instance;

+ (instancetype)sharedInstance {
	if (!instance) {
		instance = [[BSHighlightEffectManager alloc] init];
	}
    return instance;
}

+ (void)clearSharedInstance {
	instance = nil;
}

- (NSURL *)_getAudioUrlWithName:(NSString *)name {
	return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
}

- (id)init {
    self = [super init];
    if (self) {
        NSMutableArray *effects = [NSMutableArray array];
		[effects addObject:[BSHighlightEffectModel0 highlightEffectModelWithName:ZPLocalizedString(@"NO EFFECT") iconNormal:@"capture_noeffect_active" iconHighlight:@"capture_noeffect_inactive" audioUrl:nil compositionLayerClass:nil videoCompositorClass:nil]];
		[effects addObject:[BSHighlightEffectModel1 highlightEffectModelWithName:ZPLocalizedString(@"DEMO EFFECT 1") iconNormal:@"capture_demoeffect_active" iconHighlight:@"capture_demoeffect_inactive" audioUrl:[self _getAudioUrlWithName:@"Zepp TV 1"] compositionLayerClass:[BSEffectCompositionLayer1 class] videoCompositorClass:[BSEffectVideoCompositor1 class]]];
		[effects addObject:[BSHighlightEffectModel2 highlightEffectModelWithName:ZPLocalizedString(@"DEMO EFFECT 2") iconNormal:@"capture_demoeffect_active" iconHighlight:@"capture_demoeffect_inactive" audioUrl:[self _getAudioUrlWithName:@"Zepp TV 2"] compositionLayerClass:[BSEffectCompositionLayer2 class] videoCompositorClass:[BSEffectVideoCompositor2 class]]];
        _highlightEffectModels = [NSArray arrayWithArray:effects];
    }
    
    return self;
}

- (void)dealloc {
	
}

- (BSHighlightEffectModel0 *)noEffectModel {
	return [_highlightEffectModels firstObject];
}

- (BSHighlightEffectModel2 *)effectModel2 {
	return _highlightEffectModels[2];
}

@end
