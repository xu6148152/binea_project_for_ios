//
//  BSFeedRequestTest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSBaseTest.h"
#import "BSFeedTimelineHttpRequest.h"
#import "BSFeedDataModel.h"

@interface BSFeedRequestTest : BSBaseTest

@end

@implementation BSFeedRequestTest

static DataModelIdType highlightId;

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void)testFeedOlderRequest {
	BSFeedTimelineHttpRequest *request = [BSFeedTimelineHttpRequest request];
	request.olderThanHighlightId = highlightId;

	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
