//
//  BSTeamUpdateHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamBaseHttpRequest.h"

@interface BSTeamUpdateHttpRequest : BSTeamBaseHttpRequest

@property (nonatomic) NSString *location;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSString *sports;
@property (nonatomic) UIImage *avatarImage;

@end
