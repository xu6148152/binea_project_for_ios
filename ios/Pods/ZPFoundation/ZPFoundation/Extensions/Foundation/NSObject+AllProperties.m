//
//  NSObject+AllProperties.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/8/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "NSObject+AllProperties.h"
#import <objc/runtime.h>

@implementation NSObject (AllProperties)

- (NSString *)allPropertiesDescription {
	uint outCount;
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);

	NSMutableString *strDescription = [NSMutableString string];
	[strDescription appendString:@"\n{"];
	for (uint i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
		id propertyValue = [self valueForKey:(NSString *)propertyName];
		[strDescription appendFormat:@"\n%@ : %@", propertyName, propertyValue];
	}
	[strDescription appendString:@"\n}"];

	free(properties);

	return strDescription;
}

@end
