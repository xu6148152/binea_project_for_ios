//
//  BSTeamInvitationDataModel.h
//  Bristol
//
//  Created by Yangfan Huang on 3/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSUserMO;

@interface BSInvitationDataModel : ZPBaseDataModel
@property (nonatomic) NSString *type;
@property (nonatomic) BSUserMO *user;
@property (nonatomic) NSString *email;
@end

@interface BSTeamInvitationsDataModel : ZPBaseDataModel
@property (nonatomic) NSArray *invitations;
@end