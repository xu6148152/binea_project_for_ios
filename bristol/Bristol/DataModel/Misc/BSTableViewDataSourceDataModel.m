//
//  BSTableViewDataSourceDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTableViewDataSourceDataModel.h"

@implementation BSTableViewSectionDataModel

+ (instancetype)dataModelWithSectionTitle:(NSString *)sectionTitle rowsDataModel:(NSArray *)rowsDataModel {
	return [[BSTableViewSectionDataModel alloc] initWithSectionTitle:sectionTitle rowsDataModel:rowsDataModel];
}

- (id)initWithSectionTitle:(NSString *)sectionTitle rowsDataModel:(NSArray *)rowsDataModel {
	self = [super init];
	if (self) {
		_sectionTitle = sectionTitle;
		_rowsDataModel = rowsDataModel;
	}
	return self;
}

@end


@implementation BSTableViewDataSourceDataModel

+ (instancetype)dataModelWithSections:(NSArray *)sections {
	return [[BSTableViewDataSourceDataModel alloc] initWithSections:sections];
}

- (id)initWithSections:(NSArray *)sections {
	self = [super init];
	if (self) {
		for (BSTableViewSectionDataModel *dm in sections) {
			NSParameterAssert([dm isKindOfClass:[BSTableViewSectionDataModel class]]);
		}
		_sections = sections;
	}
	return self;
}

@end
