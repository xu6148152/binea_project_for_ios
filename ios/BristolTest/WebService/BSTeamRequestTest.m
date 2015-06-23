//
//  BSTeamRequestTest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSBaseTest.h"
#import "BSTeamInfoHttpRequest.h"
#import "BSTeamAllHighlightsHttpRequest.h"
#import "BSTeamAllMembersHttpRequest.h"
#import "BSTeamAllFollowersHttpRequest.h"
#import "BSTeamApplyHttpRequest.h"
#import "BSTeamFollowHttpRequest.h"
#import "BSTeamUnfollowHttpRequest.h"
#import "BSTeamCreateHttpRequest.h"
#import "BSTeamUpdateHttpRequest.h"
#import "BSTeamDeleteHttpRequest.h"
#import "BSTeamInviteMemberHttpRequest.h"
#import "BSTeamInviteEmailHttpRequest.h"
#import "BSTeamRemoveMemberHttpRequest.h"
#import "BSTeamPendingApplicationsHttpRequest.h"
#import "BSTeamAcceptApplicationHttpRequest.h"
#import "BSTeamRejectApplicationHttpRequest.h"

#import "BSTeamMO.h"
#import "BSSportMO.h"

@interface BSTeamRequestTest : BSBaseTest

@end

@implementation BSTeamRequestTest

static BSTeamMO *team;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test1TeamCreateRequest {
	BSTeamMO *newTeam = [BSTeamMO randomInstanceForTest];
	BSSportMO *sport = [BSSportMO sportOfIdentifier:1];
	if (sport) {
		[newTeam addSportsObject:sport];
	}
	
    BSTeamCreateHttpRequest *request = [BSTeamCreateHttpRequest request];
	request.name = newTeam.name;
	
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
		team = result.dataModel;
    }];
}

- (void)test2TeamApplyRequest {
    BSTeamApplyHttpRequest *request = [BSTeamApplyHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test2TeamFollowRequest {
    BSTeamFollowHttpRequest *request = [BSTeamFollowHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test2TeamUpdateRequest {
    BSTeamUpdateHttpRequest *request = [BSTeamUpdateHttpRequest request];
	request.teamId = team.identifierValue;
	request.sports = @"1,2,3";
		
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3TeamInfoRequest {
    BSTeamInfoHttpRequest *request = [BSTeamInfoHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3TeamHighlightsRequest {
    BSTeamAllHighlightsHttpRequest *request = [BSTeamAllHighlightsHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3TeamMembersRequest {
    BSTeamAllMembersHttpRequest *request = [BSTeamAllMembersHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3TeamFollowersRequest {
    BSTeamAllFollowersHttpRequest *request = [BSTeamAllFollowersHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3TeamPendingApplicationsRequest {
    BSTeamPendingApplicationsHttpRequest *request = [BSTeamPendingApplicationsHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamUnfollowRequest {
    BSTeamUnfollowHttpRequest *request = [BSTeamUnfollowHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamInviteMemberRequest {
    BSTeamInviteMemberHttpRequest *request = [BSTeamInviteMemberHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamInviteEmailRequest {
	BSTeamInviteEmailHttpRequest *request = [BSTeamInviteEmailHttpRequest request];
	request.teamId = team.identifierValue;
	request.emails = [NSArray arrayWithObjects:@"test1@bristol.com", @"test2@bristol.com", @"test3@bristol.com", nil];
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamRemoveMemberRequest {
    BSTeamRemoveMemberHttpRequest *request = [BSTeamRemoveMemberHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamAcceptApplicationRequest {
    BSTeamAcceptApplicationHttpRequest *request = [BSTeamAcceptApplicationHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4TeamRejectApplicationRequest {
    BSTeamRejectApplicationHttpRequest *request = [BSTeamRejectApplicationHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test7TeamDeleteRequest {
    BSTeamDeleteHttpRequest *request = [BSTeamDeleteHttpRequest request];
    request.teamId = team.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
