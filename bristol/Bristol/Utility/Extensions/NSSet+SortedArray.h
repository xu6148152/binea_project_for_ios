//
//  NSSet+SortedArray.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet(SortedArray)

- (NSArray *)sortedArrayWithKey:(NSString *)key ascending:(BOOL)ascending;

@end
