//
//  ZPAssistanceActionsManager.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPAssistanceActionsManager.h"
#import "GTMObjectSingleton.h"

@interface ZPAssistanceActionsManager ()
{
	NSMutableArray *_aryActions;
	NSUInteger _defaultActionIndex;
	ZPVoidBlock _defaultActionDidChangedCallback;
}

@end

#define kDefaultActionIndex @"kDefaultActionIndex"

@implementation ZPAssistanceActionsManager

GTMOBJECT_SINGLETON_BOILERPLATE(ZPAssistanceActionsManager, sharedInstance)

- (id)init {
	self = [super init];
	if (self) {
		_aryActions = [NSMutableArray array];

		_defaultActionIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultActionIndex];
	}
	return self;
}

- (NSArray *)actions {
	return [NSArray arrayWithArray:_aryActions];
}

- (NSObject <ZPAssistanceActionProtocol> *)defaultAction {
	if (_defaultActionIndex < _aryActions.count) {
		return _aryActions[_defaultActionIndex];
	}
	else {
		return [_aryActions firstObject];
	}
}

- (void)addAction:(NSObject <ZPAssistanceActionProtocol> *)action {
	if ([action conformsToProtocol:@protocol(ZPAssistanceActionProtocol)]) {
		[_aryActions addObject:action];

		ZPInvokeBlock(_defaultActionDidChangedCallback);
	}
}

- (void)setDefaultActionIndex:(NSUInteger)index {
	if (index < _aryActions.count && _defaultActionIndex != index) {
		_defaultActionIndex = index;
		[[NSUserDefaults standardUserDefaults] setInteger:_defaultActionIndex forKey:kDefaultActionIndex];

		ZPInvokeBlock(_defaultActionDidChangedCallback);
	}
}

- (void)defaultActionDidChangedCallback:(ZPVoidBlock)callback {
	_defaultActionDidChangedCallback = callback;
}

@end
