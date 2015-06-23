//
//  NSObject+ClassName.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "NSObject+ClassName.h"

@implementation NSObject(ClassName)

+ (NSString *)className {
	return NSStringFromClass([self class]);
}

@end
