//
//  ZPBaseHttpRequest.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/19/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ZPHttpResponseMappingProtocol.h"
#import "RestKit.h"

@class ZPMultipartItem;

typedef void (^ZPHttpRequestCompletedBlock) (id<ZPHttpResponseMappingProtocol> result);

typedef         NS_ENUM (NSInteger, ZPRequestControl) {
	ZPRequestControlLoginRequired = 0,
	ZPRequestControlAllowAnonymas
};

extern NSString *const ZPRESTfulDomain;


@interface ZPBaseHttpRequest : NSObject

@property (nonatomic, strong, readonly) RKObjectRequestOperation *requestOperation;
@property (nonatomic, strong) ZPMultipartItem *multipartItem;
@property (nonatomic) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSURL *baseUrl; // defaults to [[ZPApiUrlManager sharedInstance] currentApiUrl]
@property (nonatomic, assign) NSInteger statusSuccessValue; // defaults to 0

+ (instancetype)request;

- (void)postRequest;
- (void)postRequestCustomizedWithSucceedBlock:(ZPHttpRequestCompletedBlock)succeedBlock failedBlock:(ZPHttpRequestCompletedBlock)failedBlock;

- (void)cancelRequest;

// overwrite optional
- (RKRequestDescriptor *)requestDescriptor;
- (RKResponseDescriptor *)responseDescriptor;
- (ZPRequestControl)requestControl; // default is ZPRequestControlLoginRequired
+ (RKRequestMethod)requestMethod; // default is RKRequestMethodPOST
- (void)onRequestSucceed:(id<ZPHttpResponseMappingProtocol>)result;
- (void)onRequestFailed:(id<ZPHttpResponseMappingProtocol>)result;

// overwrite required
+ (NSString *)requestPath;
+ (NSString *)responsePath;
+ (RKObjectMapping *)requestMapping;
+ (RKMapping *)responseMapping;
+ (RKMapping *)responseMappingCustomized;

@end
