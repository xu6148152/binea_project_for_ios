//
//  BSTeamCreateHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamBaseHttpRequest.h"

@class BSTeamMO;

@interface BSTeamCreateHttpRequest : BSCustomHttpRequest

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *location;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) NSString *sports;
@property (nonatomic) UIImage *avatarImage;

@end
