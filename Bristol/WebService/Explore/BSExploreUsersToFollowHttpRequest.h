//
//  BSExploreUsersToFollowHttpRequest.h
//  Bristol
//
//  Created by Bo on 4/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSExploreUsersToFollowHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType user_id;

@end
