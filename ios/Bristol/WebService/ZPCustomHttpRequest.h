//
//  ZPCustomHttpRequest.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 1/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseHttpRequest.h"
#import "ZPHttpResponseDataModel.h"

typedef void (^ZPCustomHttpRequestCompletedBlock) (ZPHttpResponseDataModel *result);

@interface ZPCustomHttpRequest : ZPBaseHttpRequest

@property (nonatomic, strong) NSString *authToken; // required

- (void)postRequestWithSucceedBlock:(ZPCustomHttpRequestCompletedBlock)succeedBlock failedBlock:(ZPCustomHttpRequestCompletedBlock)failedBlock;

@end
