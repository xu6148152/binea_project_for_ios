//
//  BSSignUpWithEmailHttpRequest.m
//  Bristol
//
//  Created by Bo on 3/23/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSignUpWithEmailHttpRequest.h"
#import "BSUserMO.h"
#import "BSUsersDataModel.h"
#import "BSDataManager.h"

@implementation BSSignUpWithEmailHttpRequest
+ (instancetype)requestWithEmail:(NSString *)email password:(NSString *)password {
    BSSignUpWithEmailHttpRequest *request = [[BSSignUpWithEmailHttpRequest alloc] init];
    
    request.email = email;
    request.password = password;
    
    return request;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"account/sign_up";
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"email" : @"email",
                                                   @"password" : @"password",
                                                   @"name_id" : @"username",
                                                   @"name_human_readable" : @"screen_name"
                                                   }];
    return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSSignUpDataModel responseMapping];
}

- (void)postRequestWithSucceedBlock:(BSHttpRequestCompletedBlock)succeedBlock failedBlock:(BSHttpRequestCompletedBlock)failedBlock {
    [super postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
        [[BSDataManager sharedInstance] saveCookie];
        
        ZPInvokeBlock(succeedBlock, result);
    } failedBlock:failedBlock];
}

@end
