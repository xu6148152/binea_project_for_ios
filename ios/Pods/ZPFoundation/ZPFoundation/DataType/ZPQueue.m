//
//  ZPQueue.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/1/14.
//
//

#import "ZPQueue.h"

@implementation ZPQueue
{
	NSMutableArray *_array;
}

- (id)initWithMaxSize:(NSUInteger)maxSize {
	if ((self = [self init])) {
		_maxSize = maxSize;
	}

	return self;
}

- (id)init {
	if ((self = [super init])) {
		_array = [[NSMutableArray alloc] init];
		_maxSize = NSUIntegerMax;
	}

	return self;
}

- (id)peek {
	if (_array.count > 0)
		return [_array objectAtIndex:0];

	return nil;
}

- (id)dequeue {
	if (_array.count > 0) {
		id object = [self peek];
		[_array removeObjectAtIndex:0];
		return object;
	}

	return nil;
}

- (id)enqueue:(id)element {
	if (!element)
		return nil;

	[_array addObject:element];
	if (_array.count > _maxSize) {
		id elementToRemove = _array[0];
		[_array removeObjectAtIndex:0];
		return elementToRemove;
	}
	return nil;
}

- (void)enqueueElementsFromArray:(NSArray *)array {
	[_array addObjectsFromArray:array];
}

- (void)enqueueElementsFromQueue:(ZPQueue *)queue {
	while (![queue isEmpty]) {
		[self enqueue:[queue dequeue]];
	}
}

- (void)clear {
	[_array removeAllObjects];
}

- (BOOL)isEmpty {
	return _array.count == 0;
}

- (NSInteger)size {
	return _array.count;
}

- (NSArray *)allElements {
	return [NSArray arrayWithArray:_array];
}

@end
