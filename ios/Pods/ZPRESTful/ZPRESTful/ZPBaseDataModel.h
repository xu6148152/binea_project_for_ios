//
//  ZPBaseDataModel.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPHttpResponseMappingProtocol.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface ZPBaseDataModel : NSObject <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol>

@property (nonatomic, strong) NSError *error;

+ (instancetype)modelWithError:(NSError *)error;

@end
