//
//  BSHighlightPlaceDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightPlaceDataModel.h"
#import "BSDataModels.h"

@interface BSHighlightPlaceDataModel()
{
	NSString *_nameLocalized;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *name_zh_cn;

@end


@implementation BSHighlightPlaceDataModel

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"id" : @"identifier",
	     @"name" : @"name",
		 @"zh_name" : @"name_zh_cn",
	     @"latitude" : @"latitude",
	     @"longitude" : @"longitude",
	 }];

	return mapping;
}

- (void)setName:(NSString *)name {
	_name = name;
	_nameLocalized = nil;
}

- (void)setName_zh_cn:(NSString *)name_zh_cn {
	_name_zh_cn = name_zh_cn;
	_nameLocalized = nil;
}

- (NSString *)nameLocalized {
	if (!_nameLocalized) {
		NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
		NSRange range = [languageCode rangeOfString:@"zh"];
		if (range.length > 0 && range.location == 0) {
			_nameLocalized = self.name_zh_cn ?: self.name;
		} else {
			_nameLocalized = self.name;
		}
	}
	return _nameLocalized;
}

@end


@implementation BSHighlightPlacesDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"places" toKeyPath:@"places" withMapping:[BSHighlightPlaceDataModel responseMapping]]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"events" toKeyPath:@"events" withMapping:[BSEventMO responseMapping]]];
	
    return mapping;
}

@end