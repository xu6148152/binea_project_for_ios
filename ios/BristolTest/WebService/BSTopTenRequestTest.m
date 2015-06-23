//
//  BSTopTenRequestTest.m
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSBaseTest.h"
#import "BSTopTenFriendsHttpRequest.h"
#import "BSTopTenFollowedEventsHttpRequest.h"
#import "BSTopTenSportHttpRequest.h"

@interface BSTopTenRequestTest : BSBaseTest

@end

@implementation BSTopTenRequestTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHighlightTopTenFriendsRequest {
    BSTopTenFriendsHttpRequest *request = [BSTopTenFriendsHttpRequest request];
    request.week = 201503230;
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testHighlightTopTenFollowedEventsRequest {
    BSTopTenFollowedEventsHttpRequest *request = [BSTopTenFollowedEventsHttpRequest request];
    request.week = 201503300;
    request.event_id = 1;
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testHighlightTopTenSportRequest {
    BSTopTenSportHttpRequest *request = [BSTopTenSportHttpRequest request];
    request.week = 201503300;
    request.sport_type = 1;
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
