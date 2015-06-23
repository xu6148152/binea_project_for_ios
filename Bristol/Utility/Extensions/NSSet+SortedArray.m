//
//  NSSet+SortedArray.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "NSSet+SortedArray.h"

@implementation NSSet(SortedArray)

- (NSArray *)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
	NSArray *ary = self.allObjects;
	if (key.length > 0) {
		ary = [ary sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
	}
	return ary;
}

@end
