//
//  BSTableViewDataSourceDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/21/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTableViewSectionDataModel : NSObject

@property(nonatomic, strong) NSString *sectionTitle;
@property(nonatomic, strong) NSArray *rowsDataModel;

+ (instancetype)dataModelWithSectionTitle:(NSString *)sectionTitle rowsDataModel:(NSArray *)rowsDataModel;
- (id)initWithSectionTitle:(NSString *)sectionTitle rowsDataModel:(NSArray *)rowsDataModel;

@end


@interface BSTableViewDataSourceDataModel : NSObject

@property(nonatomic, strong) NSArray *sections;

+ (instancetype)dataModelWithSections:(NSArray *)sections;
- (id)initWithSections:(NSArray *)sections;

@end
