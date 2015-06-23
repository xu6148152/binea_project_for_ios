//
//  ZPAssistanceActionsManager.h
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAssistanceActionProtocol.h"
#import "ZPMacros.h"

@interface ZPAssistanceActionsManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)actions;
- (NSObject <ZPAssistanceActionProtocol> *)defaultAction;
- (void)addAction:(NSObject <ZPAssistanceActionProtocol> *)action;

- (void)setDefaultActionIndex:(NSUInteger)index;
- (void)defaultActionDidChangedCallback:(ZPVoidBlock)callback;

@end
