//
//  ZPHttpResponseDataModel.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/19/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

typedef NS_ENUM (NSInteger, ZPHttpResponseStatus) {
	ZPHttpResponseStatusNotLoggedIn = -100,
	ZPHttpResponseStatusNoNetworkConnection = -101,
};


@interface ZPHttpResponseDataModel : ZPBaseDataModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *messageDebug;
@property (nonatomic, strong) id dataModel;

+ (instancetype)modelWithStatus:(NSInteger)status message:(NSString *)message;
+ (instancetype)modelWithStatus:(NSInteger)status message:(NSString *)message error:(NSError *)error;

@end
