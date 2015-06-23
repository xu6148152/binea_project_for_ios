//
//  BSExploreRequestTest.m
//  Bristol
//
//  Created by Yangfan Huang on 2/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BSBaseTest.h"
#import "BSExploreTeamsHttpRequest.h"
#import "BSExploreHighlightsHttpRequest.h"
#import "BSExploreEventsHttpRequest.h"
#import "BSUserTeamsDataModel.h"
#import "BSEventsDataModel.h"
#import "BSTeamMO.h"
#import "BSUserMO.h"
#import "BSExploreSearchPeopleHttpRequest.h"
#import "BSUsersDataModel.h"
#import "BSExploreSearchTeamsHttpRequest.h"
#import "BSExploreSearchEventsHttpRequest.h"
#import "BSExploreUsersToFollowHttpRequest.h"

@interface BSExploreRequestTest : BSBaseTest

@end

@implementation BSExploreRequestTest

- (void)testExploreHighlightsRequest {
	BSExploreHighlightsHttpRequest *request = [BSExploreHighlightsHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}


- (void)testExploreTeamsRequest {
	BSExploreTeamsHttpRequest *request = [BSExploreTeamsHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
	}];
}

- (void)testExploreEventsRequest {
	BSExploreEventsHttpRequest *request = [BSExploreEventsHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
	}];
}

- (void)testExploreSearchPeopleRequest {
	BSExploreSearchPeopleHttpRequest *request = [BSExploreSearchPeopleHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
	}];}

- (void)testExploreSearchTeamRequest {
	BSExploreSearchTeamsHttpRequest *request = [BSExploreSearchTeamsHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
	}];}

- (void)testExploreSearchEventRequest {
	BSExploreSearchEventsHttpRequest *request = [BSExploreSearchEventsHttpRequest request];
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
	}];}

- (void)testBSExploreUsersToFollowRequest {
    BSExploreUsersToFollowHttpRequest *request = [BSExploreUsersToFollowHttpRequest request];
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
    }];}



@end
