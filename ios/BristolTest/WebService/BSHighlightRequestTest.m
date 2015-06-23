//
//  BSHighlightRequestTest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSBaseTest.h"
#import "BSHighlightPostHttpRequest.h"
#import "BSHighlightPostUploadVideoHttpRequest.h"
#import "BSHighlightAllLikesHttpRequest.h"
#import "BSHighlightAllCommentsHttpRequest.h"
#import "BSHighlightLikeHttpRequest.h"
#import "BSHighlightUnlikeHttpRequest.h"
#import "BSHighlightCommentHttpRequest.h"
#import "BSHighlightUncommentHttpRequest.h"
#import "BSQueryNearbyPlacesHttpRequest.h"
#import "BSHighlightReportHttpRequest.h"
#import "BSLogHighlightHttpRequest.h"
#import "BSHighlightDeleteHttpRequest.h"
#import "BSHighlightGetShareUrlHttpRequest.h"

#import "BSHighlightMO.h"
#import "BSCommentMO.h"

@interface BSHighlightRequestTest : BSBaseTest

@end

@implementation BSHighlightRequestTest

static BSHighlightMO *highlight;
static BSCommentMO *comment;

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void)test1HighlightPostRequest {
	DataModelIdType clientId = [[NSDate date] timeIntervalSince1970];
	
	NSBundle *bundle = [NSBundle bundleForClass:[self class]]; // get a valid bundle for test target
	NSString *path = [bundle pathForResource:@"testupload" ofType:@"mp4"];
	
	BSHighlightPostUploadVideoHttpRequest *requestUploadVideo = [BSHighlightPostUploadVideoHttpRequest requestWithVideoFullPath:path];
	requestUploadVideo.clientId = clientId;
	[self asyncTestForRequest:requestUploadVideo expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
		BSHighlightPostHttpRequest *request = [BSHighlightPostHttpRequest request];
		request.name = [NSString randomStringWithLength:5];
		request.message = [NSString randomStringWithLength:20];
		request.sportType = 1;
		request.latitude = [NSNumber randomFloatFrom:0 to:180];
		request.longitude = [NSNumber randomFloatFrom:0 to:180];
		request.locationName = [NSString randomStringWithLength:5];
		request.clientId = clientId;
		
		[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
			highlight = result.dataModel;
		}];
	}];
}

- (void)test3HighlightLikeRequest {
	BSHighlightLikeHttpRequest *request = [BSHighlightLikeHttpRequest request];
	request.highlightId = highlight.identifierValue;

	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test3HighlightCommentRequest {
	BSHighlightCommentHttpRequest *request = [BSHighlightCommentHttpRequest request];
	request.highlightId = highlight.identifierValue;
	request.content = @"Hey! good job!";

	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
        if ([result.dataModel isKindOfClass:[NSArray class]]) {
            comment = ((NSArray *)result.dataModel)[0];
        }
    }];
}

- (void)test3HighlightLogRequest {
    BSLogHighlightHttpRequest *request = [BSLogHighlightHttpRequest requestWithLogHighlightDataModels:@[[BSLogHighlightDataModel dataModelWithHighlightId:highlight.identifierValue playedTimes:[NSNumber randomIntegerFrom:1 to:10]]]];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4HighlightCommentsRequest {
    BSHighlightAllCommentsHttpRequest *request = [BSHighlightAllCommentsHttpRequest request];
    request.highlightId = highlight.identifierValue;
    request.olderThanCommentId = 0;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4HighlightLikesRequest {
    BSHighlightAllLikesHttpRequest *request = [BSHighlightAllLikesHttpRequest request];
    request.highlightId = highlight.identifierValue;
    request.lastUserId = 0;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test4HighlightQueryNearbyPlacesRequest {
    BSQueryNearbyPlacesHttpRequest *request = [BSQueryNearbyPlacesHttpRequest request];
    request.latitude = [NSNumber randomFloatFrom:-90 to:90];
    request.longitude = [NSNumber randomFloatFrom:-180 to:180];
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test5HighlightUnlikeRequest {
    BSHighlightUnlikeHttpRequest *request = [BSHighlightUnlikeHttpRequest request];
    request.highlightId = highlight.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test5HighlightUncommentRequest {
	BSHighlightUncommentHttpRequest *request = [BSHighlightUncommentHttpRequest request];
	request.highlightId = highlight.identifierValue;
	request.commentId = comment.identifierValue;

	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test6HighlightReportRequest {
	BSHighlightReportHttpRequest *request = [BSHighlightReportHttpRequest request];
	request.highlightId = highlight.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test6HighlightGetShareUrlRequest {
	BSHighlightGetShareUrlHttpRequest *request = [BSHighlightGetShareUrlHttpRequest request];
	request.highlightId = 816;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)test7HighlightDeleteRequest {
	BSHighlightDeleteHttpRequest *request = [BSHighlightDeleteHttpRequest request];
	request.highlightId = highlight.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
