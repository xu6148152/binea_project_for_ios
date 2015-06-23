//
//  BSBaseTest.h
//  Bristol
//
//  Created by Bo on 1/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CoreData+MagicalRecord.h"

#import "BSCustomHttpRequest.h"

#define kUnitTestCachedToken @"kUnitTestCachedToken"
#define kUnitTestEmail @"dev.ios.unittest@zepplabs.com"
#define kUnitTestPassword @"654321"

static NSTimeInterval kDefaultAsynchronousTestingTimeOut = 60; // in seconds

@interface BSBaseTest : XCTestCase

- (NSString *)getCachedToken;

- (void)asyncTestForRequest:(BSCustomHttpRequest *)request expectStatus:(NSInteger)expectStatus description:(NSString *)description;
- (void)asyncTestForRequest:(BSCustomHttpRequest *)request expectStatus:(NSInteger)expectStatus description:(NSString *)description succeedBlock:(BSHttpRequestCompletedBlock)succeedBlock;

@end
