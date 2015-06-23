//
//  BSCustomHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseHttpRequest.h"
#import "BSHttpResponseDataModel.h"

typedef void (^BSHttpRequestCompletedBlock) (BSHttpResponseDataModel *result);

@interface BSCustomHttpRequest : ZPBaseHttpRequest

- (void)postRequestWithSucceedBlock:(BSHttpRequestCompletedBlock)succeedBlock failedBlock:(BSHttpRequestCompletedBlock)failedBlock;

@end
