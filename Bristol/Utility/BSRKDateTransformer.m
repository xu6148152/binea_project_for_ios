//
//  BSRKDateTransformer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/24/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSRKDateTransformer.h"

@implementation BSRKDateTransformer

// Ref: https://github.com/RestKit/RestKit/issues/1587
+ (RKBlockValueTransformer *)timeIntervalInMilliSecondSince1970ToDateValueTransformer
{
	static dispatch_once_t onceToken;
	static RKBlockValueTransformer *valueTransformer;
	dispatch_once(&onceToken, ^{
		valueTransformer = [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
			return ((([sourceClass isSubclassOfClass:[NSString class]] || [sourceClass isSubclassOfClass:[NSNumber class]]) && [destinationClass isSubclassOfClass:[NSDate class]]) ||
					([sourceClass isSubclassOfClass:[NSDate class]] && ([destinationClass isSubclassOfClass:[NSNumber class]] || [destinationClass isSubclassOfClass:[NSString class]])));
		} transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputValueClass, NSError *__autoreleasing *error) {
			static dispatch_once_t onceToken;
			static NSArray *validClasses;
			static NSNumberFormatter *numberFormatter;
			dispatch_once(&onceToken, ^{
				validClasses = @[ [NSNumber class], [NSString class], [NSDate class] ];
				numberFormatter = [NSNumberFormatter new];
				numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
			});
			RKValueTransformerTestInputValueIsKindOfClass(inputValue, validClasses, error);
			RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, validClasses, error);
			if ([outputValueClass isSubclassOfClass:[NSDate class]]) {
				if ([inputValue isKindOfClass:[NSNumber class]]) {
					*outputValue = [NSDate dateWithTimeIntervalSince1970:[inputValue doubleValue] / 1000];
				} else if ([inputValue isKindOfClass:[NSString class]]) {
					if ([[inputValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
						*outputValue = nil;
						return YES;
					}
					NSString *errorDescription = nil;
					NSNumber *formattedNumber;
					BOOL success = [numberFormatter getObjectValue:&formattedNumber forString:inputValue errorDescription:&errorDescription];
					RKValueTransformerTestTransformation(success, error, @"%@", errorDescription);
					*outputValue = [NSDate dateWithTimeIntervalSince1970:[formattedNumber doubleValue] / 1000];
				}
			} else if ([outputValueClass isSubclassOfClass:[NSNumber class]]) {
				*outputValue = @([inputValue timeIntervalSince1970] / 1000);
			} else if ([outputValueClass isSubclassOfClass:[NSString class]]) {
				*outputValue = [numberFormatter stringForObjectValue:@([inputValue timeIntervalSince1970] / 1000)];
			}
			return YES;
		}];
		
		valueTransformer.name = NSStringFromSelector(_cmd);
	});
	
	return valueTransformer;
}

@end
