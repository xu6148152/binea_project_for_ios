//
//  BSEventRequestTest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSBaseTest.h"
#import "BSEventInfoHttpRequest.h"
#import "BSEventAllHighlightsHttpRequest.h"
#import "BSEventAllFollowersHttpRequest.h"
#import "BSEventFollowHttpRequest.h"
#import "BSEventUnfollowHttpRequest.h"
#import "BSEventCreateHttpRequest.h"
#import "BSEventUpdateHttpRequest.h"
#import "BSEventEndHttpRequest.h"
#import "BSEventCloseFromTimelineHttpRequest.h"

#import "BSEventMO.h"

@interface BSEventRequestTest : BSBaseTest

@end

@implementation BSEventRequestTest

static BSEventMO *event;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (DataModelIdType)_getEventId {
	return 3;
//	return event.identifierValue;
}

- (void)test1EventCreateRequest {
    BSEventCreateHttpRequest *request = [BSEventCreateHttpRequest request];
    request.event = [BSEventMO randomInstanceForTest];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
        event = result.dataModel;
    }];
}

- (void)test2EventFollowRequest {
    BSEventFollowHttpRequest *request = [BSEventFollowHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3EventInfoRequest {
    BSEventInfoHttpRequest *request = [BSEventInfoHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3EventHighlightsRequest {
    BSEventAllHighlightsHttpRequest *request = [BSEventAllHighlightsHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3EventFollowersRequest {
    BSEventAllFollowersHttpRequest *request = [BSEventAllFollowersHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4EventUnfollowRequest {
    BSEventUnfollowHttpRequest *request = [BSEventUnfollowHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4EventUpdateRequest {
    BSEventUpdateHttpRequest *request = [BSEventUpdateHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4EventCloseFromTimelineRequest {
	BSEventCloseFromTimelineHttpRequest *request = [BSEventCloseFromTimelineHttpRequest request];
	request.eventId = [self _getEventId];
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test5EventEndRequest {
    BSEventEndHttpRequest *request = [BSEventEndHttpRequest request];
    request.eventId = [self _getEventId];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
