//
//  ZPCFQueue.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/1/14.
//
//

#import <Foundation/Foundation.h>

@interface ZPCFQueue : NSObject

@property (nonatomic, assign, readonly) NSUInteger maxSize;

- (id)initWithMaxSize:(NSUInteger)maxSize;

- (const void *)peek;
- (const void *)dequeue;
- (const void *)enqueue:(const void *)element;
- (void)enqueueElementsFromArray:(CFArrayRef)array;
- (void)enqueueElementsFromQueue:(ZPCFQueue *)queue;
- (void)clear;

- (BOOL)isEmpty;
- (NSInteger)size;
- (NSArray *)allElements;

@end
