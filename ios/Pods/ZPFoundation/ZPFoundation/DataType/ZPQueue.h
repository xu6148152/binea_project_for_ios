//
//  ZPQueue.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/1/14.
//
//

#import <Foundation/Foundation.h>

@interface ZPQueue : NSObject

@property (nonatomic, assign, readonly) NSUInteger maxSize;

- (id)initWithMaxSize:(NSUInteger)maxSize;

- (id)peek;
- (id)dequeue;
- (id)enqueue:(id)element;
- (void)enqueueElementsFromArray:(NSArray *)array;
- (void)enqueueElementsFromQueue:(ZPQueue *)queue;
- (void)clear;

- (BOOL)isEmpty;
- (NSInteger)size;
- (NSArray *)allElements;

@end
