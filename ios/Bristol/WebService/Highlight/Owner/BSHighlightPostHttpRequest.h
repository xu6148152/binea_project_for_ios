//
//  BSHighlightPostHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSHighlightPostHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType clientId;
@property (nonatomic, assign) DataModelIdType teamId;
@property (nonatomic, assign) DataModelIdType eventId;
@property (nonatomic, assign) NSInteger sportType;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *shareTypes;
@property (nonatomic, strong) NSDate *shoot_at;

@end
