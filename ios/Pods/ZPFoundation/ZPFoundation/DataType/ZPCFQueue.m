//
//  ZPCFQueue.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/1/14.
//
//

#import "ZPCFQueue.h"

@implementation ZPCFQueue
{
	CFMutableArrayRef _array;
}

- (id)initWithMaxSize:(NSUInteger)maxSize {
	if ((self = [self init])) {
		_maxSize = maxSize;
	}

	return self;
}

- (id)init {
	if ((self = [super init])) {
		_array = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
		_maxSize = NSUIntegerMax;
	}

	return self;
}

- (void)dealloc {
	CFRelease(_array);
}

- (const void *)peek {
	if (CFArrayGetCount(_array) > 0)
		return CFArrayGetValueAtIndex(_array, 0);

	return nil;
}

- (const void *)dequeue {
	if (CFArrayGetCount(_array) > 0) {
		const void *object = [self peek];
		CFArrayRemoveValueAtIndex(_array, 0);
		return object;
	}

	return nil;
}

- (const void *)enqueue:(const void *)element {
	if (!element)
		return nil;

	CFArrayAppendValue(_array, element);
	if (CFArrayGetCount(_array) > _maxSize) {
		const void *elementToRemove = CFArrayGetValueAtIndex(_array, 0);
		CFArrayRemoveValueAtIndex(_array, 0);
		return elementToRemove;
	}

	return nil;
}

- (void)enqueueElementsFromArray:(CFArrayRef)array {
	CFArrayAppendArray(_array, array, CFRangeMake(0, CFArrayGetCount(array)));
}

- (void)enqueueElementsFromQueue:(ZPCFQueue *)queue {
	while (![queue isEmpty]) {
		[self enqueue:[queue dequeue]];
	}
}

- (void)clear {
	CFArrayRemoveAllValues(_array);
}

- (BOOL)isEmpty {
	return CFArrayGetCount(_array) == 0;
}

- (NSInteger)size {
	return CFArrayGetCount(_array);
}

- (NSArray *)allElements {
	return (__bridge NSArray *)_array;
}

@end
