//
//  BSTeamPendingInvitationsHttpRequest.m
//  Bristol
//
//  Created by Yangfan Huang on 3/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamPendingInvitationsHttpRequest.h"
#import "BSTeamInvitationsDataModel.h"
#import "BSTeamMO.h"

@implementation BSTeamPendingInvitationsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"team/pending_invitations";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];
	
	[mapping addAttributeMappingsFromDictionary:@{ @"teamId" : @"team_id" }];
	return mapping;
}

+ (NSString *)responsePath {
	return nil;
}

+ (RKMapping *)responseMapping {
	return [BSTeamInvitationsDataModel responseMapping];
}

- (void) onRequestSucceed:(BSHttpResponseDataModel *)result {
	BSTeamMO *team = [BSTeamMO MR_findFirstByAttribute:@"identifier" withValue:@(self.teamId)];
	BSTeamInvitationsDataModel *dataModel = result.dataModel;
	if (team && dataModel && dataModel.invitations) {
		[team.pendingUsers removeAllObjects];
		[team.pendingEmails removeAllObjects];
		
		for (BSInvitationDataModel *invitation in dataModel.invitations) {
			if ([invitation.type isEqualToString:@"account"]) {
				if (invitation.user) {
					[team.pendingUsers addObject:invitation.user];
				}
			} else {
				if (invitation.email) {
					[team.pendingEmails addObject:invitation.email];
				}
			}
		}
	}
}
@end
