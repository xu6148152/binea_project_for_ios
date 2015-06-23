//
//  NSDictionary+Addition.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "NSDictionary+Addition.h"

@implementation NSDictionary (Addition)

- (NSDictionary *)reversedKeyValueDictionary {
	NSMutableDictionary *dicReversedKeyValue = [NSMutableDictionary dictionary];

	for (NSString *key in[self allKeys]) {
		dicReversedKeyValue[self[key]] = key;
	}

	return [NSDictionary dictionaryWithDictionary:dicReversedKeyValue];
}

@end
