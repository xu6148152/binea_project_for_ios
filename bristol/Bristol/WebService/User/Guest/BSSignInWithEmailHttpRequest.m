//
//  BSSignInWithEmailHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSignInWithEmailHttpRequest.h"
#import "BSUserMO.h"
#import "BSDataManager.h"

@implementation BSSignInWithEmailHttpRequest

+ (instancetype)requestWithEmail:(NSString *)email password:(NSString *)password {
    BSSignInWithEmailHttpRequest *request = [[BSSignInWithEmailHttpRequest alloc] init];
    
    request.email = email;
    request.password = password;
    
    return request;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"account/sign_in";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{ @"email" : @"email",
	                                               @"password" : @"password" }];
	return mapping;
}

+ (NSString *)responsePath {
	return @"user";
}

+ (RKMapping *)responseMapping {
	return [BSUserMO responseMapping];
}

- (void)postRequestWithSucceedBlock:(BSHttpRequestCompletedBlock)succeedBlock failedBlock:(BSHttpRequestCompletedBlock)failedBlock {
	[super postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
	    [[BSDataManager sharedInstance] saveCookie];

        ZPInvokeBlock(succeedBlock, result);
	} failedBlock:failedBlock];
}

@end
