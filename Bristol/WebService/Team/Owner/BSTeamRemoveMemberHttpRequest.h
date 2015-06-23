//
//  BSTeamRemoveMemberHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamBaseHttpRequest.h"

@interface BSTeamRemoveMemberHttpRequest : BSTeamBaseHttpRequest
@property (nonatomic, assign) DataModelIdType memberId;

@end
