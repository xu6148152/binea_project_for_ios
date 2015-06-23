//
//  BSHighlightPlaceDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSHighlightPlaceDataModel : ZPBaseDataModel

@property (nonatomic, assign) DataModelIdType identifier;
@property (nonatomic, strong, readonly) NSString *nameLocalized;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

@end


@interface BSHighlightPlacesDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *events;

@end
