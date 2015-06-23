//
//  BS1UserRequestTest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSDataManager.h"

#import "BSBaseTest.h"
#import "BSSignInWithEmailHttpRequest.h"
#import "BSUserHighlightsHttpRequest.h"
#import "BSUserFollowersHttpRequest.h"
#import "BSUserFollowingHttpRequest.h"
#import "BSUserPublicFollowHttpRequest.h"
#import "BSUserPrivateFollowHttpRequest.h"
#import "BSUserUnfollowHttpRequest.h"
#import "BSUserTeamsHttpRequest.h"
#import "BSUserEventsHttpRequest.h"
#import "BSUserInfoHttpRequest.h"
#import "BSUserInfoWithUsernameHttpRequest.h"
#import "BSMeProfileHttpRequest.h"
#import "BSMeUpdateProfileHttpRequest.h"
#import "BSMeChangePasswordHttpRequest.h"
#import "BSMeNotificationHttpRequest.h"
#import "BSMeSetUsernameHttpRequest.h"
#import "BSCheckEmailHttpRequest.h"

#import "BSUserMO.h"

@interface BS1UserRequestTest : BSBaseTest

@end

@implementation BS1UserRequestTest

static BSUserMO *user;

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void)test1UserSignInRequest {
	BSSignInWithEmailHttpRequest *request = [BSSignInWithEmailHttpRequest request];
	request.email = @"bristol_dev@zepplabs.com";
	request.password = @"121212A";

	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd) succeedBlock:^(BSHttpResponseDataModel *result) {
        user = result.dataModel;
    }];
}

- (void)testUserHighlightsRequest {
    BSUserHighlightsHttpRequest *request = [BSUserHighlightsHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserFollowersRequest {
    BSUserFollowersHttpRequest *request = [BSUserFollowersHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserFollowingRequest {
    BSUserFollowingHttpRequest *request = [BSUserFollowingHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserPublicFollowRequest {
	BSUserPublicFollowHttpRequest *request = [BSUserPublicFollowHttpRequest request];
	request.user_id = user.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserPrivateFollowRequest {
	BSUserPrivateFollowHttpRequest *request = [BSUserPrivateFollowHttpRequest request];
	request.user_id = user.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserUnfollowRequest {
	BSUserUnfollowHttpRequest *request = [BSUserUnfollowHttpRequest request];
	request.user_id = user.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserTeamsRequest {
    BSUserTeamsHttpRequest *request = [BSUserTeamsHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserEventsRequest {
    BSUserEventsHttpRequest *request = [BSUserEventsHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserProfileRequest {
    BSUserInfoHttpRequest *request = [BSUserInfoHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserProfileWithUsernameRequest {
	BSUserInfoWithUsernameHttpRequest *request = [BSUserInfoWithUsernameHttpRequest request];
	request.userName = user.name_human_readable;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testMeProfileRequest {
    BSMeProfileHttpRequest *request = [BSMeProfileHttpRequest request];
    request.user_id = user.identifierValue;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testMeUpdateProfileRequest {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testAvatar" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
	BSMeUpdateProfileHttpRequest *request = [BSMeUpdateProfileHttpRequest requestWithAvatarImage:image];

    request.user_id = user.identifierValue;
    request.privacy_allow_comments = 1;
    request.privacy_public_profile = 0;
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testMeChangePasswordRequest {
    BSMeChangePasswordHttpRequest *request = [BSMeChangePasswordHttpRequest request];
    request.user_id = user.identifierValue;
    request.oldPassword = @"121212A";
    request.currentPassword = @"121212A";
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testMeNotificationRequest {
	BSMeNotificationHttpRequest *request = [BSMeNotificationHttpRequest request];
	request.user_id = user.identifierValue;
	
	[self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

- (void)testUserCheckEmailRequest {
    BSCheckEmailHttpRequest *request = [BSCheckEmailHttpRequest request];
    request.email = @"bristol_dev@zepplabs.com";
    
    [self asyncTestForRequest:request expectStatus:0 description:NSStringFromSelector(_cmd)];
}

@end
