//
//  BSQueryPlacesByNameHttpRequest.h
//  Bristol
//
//  Created by Yangfan Huang on 3/27/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSHighlightPlaceDataModel.h"


@interface BSCitiesDataModel : ZPBaseDataModel
@property (nonatomic, strong) NSArray *cities;
@end


@interface BSQueryPlacesByNameHttpRequest : BSCustomHttpRequest
@property NSString *name;
+ (instancetype)requestWithName:(NSString *)name;
@end
