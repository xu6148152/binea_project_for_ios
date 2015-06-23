//
//  BSBaseTest.m
//  Bristol
//
//  Created by Bo on 1/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTest.h"

@implementation BSBaseTest

- (NSString *)getCachedToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kUnitTestCachedToken];
    
    return token;
}

- (void)_setCachedToken:(NSString *)token {
    if (token) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUnitTestCachedToken];
    }
}

- (void)_clearCachedToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnitTestCachedToken];
}

- (void)setUp {
    [super setUp];
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
}

- (void)asyncTestForRequest:(BSCustomHttpRequest *)request expectStatus:(NSInteger)expectStatus description:(NSString *)description {
    [self asyncTestForRequest:request expectStatus:expectStatus description:description succeedBlock:NULL];
}

- (void)asyncTestForRequest:(BSCustomHttpRequest *)request expectStatus:(NSInteger)expectStatus description:(NSString *)description succeedBlock:(BSHttpRequestCompletedBlock)succeedBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    
    [request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
        XCTAssert(result.code == expectStatus, @"expect status (%i) not be matched. result object:%@", (int)expectStatus, result);
        if ([[request class] responseMapping] != nil) {
            XCTAssert(result.dataModel != nil, @"model mapping is faild!");
        }
        [expectation fulfill];
        
        ZPInvokeBlock(succeedBlock, result);
    } failedBlock: ^(BSHttpResponseDataModel *result) {
        if ((NSInteger)result.code == 100) { // Invalid authentication token.
            [self _clearCachedToken];
        }
        XCTAssert(result.code == expectStatus, @"expect status (%i) not be matched. result object:%@", (int)expectStatus, result);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:(kDefaultAsynchronousTestingTimeOut) handler:nil];
}

@end
