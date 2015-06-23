//
//  BSHighlightEffectManager.h
//  Bristol
//
//  Created by Gary Wong on 4/15/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSHighlightEffectModel0.h"
#import "BSHighlightEffectModel1.h"
#import "BSHighlightEffectModel2.h"

@interface BSHighlightEffectManager : NSObject

@property(nonatomic, strong, readonly) NSArray *highlightEffectModels;
@property(nonatomic, strong, readonly) BSHighlightEffectModel0 *noEffectModel;
@property(nonatomic, strong, readonly) BSHighlightEffectModel2 *effectModel2;

+ (instancetype)sharedInstance;
+ (void)clearSharedInstance;

@end
