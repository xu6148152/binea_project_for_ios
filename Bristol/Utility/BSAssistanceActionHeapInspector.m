//
//  BSAssistanceActionHeapInspector.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAssistanceActionHeapInspector.h"

#ifdef DEBUG
#import "HINSPDebug.h"
#endif

@implementation BSAssistanceActionHeapInspector

- (NSString *)name {
	return @"Toggle HeapInspector";
}

- (NSString *)statusBarTitle {
	return @"Tap to toggle HeapInspector";
}

- (void)performAction {
#ifdef DEBUG
	static BOOL isStart = NO;
	isStart = !isStart;
	if (isStart) {
		[HINSPDebug startWithClassPrefix:@"BS"];
		[HINSPDebug recordBacktraces:YES];
	} else {
		[HINSPDebug stop];
	}
#endif
}

@end
