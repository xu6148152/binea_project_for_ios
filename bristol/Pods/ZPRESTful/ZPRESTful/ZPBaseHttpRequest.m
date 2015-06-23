//
//  ZPBaseHttpRequest.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/19/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreData/CoreData.h>

#import "ZPBaseHttpRequest.h"
#import "ZPBaseDataModel.h"
#import "ZPMultipartItem.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPFoundation.h"

#import "AFNetworking.h"

static NSString *const OverwriteRequiredMessage = @"overwrite is required for sub class";
NSString *const ZPRESTfulDomain = @"com.zepp.zprestful";

@interface ZPBaseHttpRequest ()
{
	RKObjectRequestOperation *_requestOperation;
}

@property (nonatomic, copy) ZPHttpRequestCompletedBlock succeedBlock;
@property (nonatomic, copy) ZPHttpRequestCompletedBlock failedBlock;

@end

@implementation ZPBaseHttpRequest

+ (instancetype)request {
	return [[self alloc] init];
}

- (id)init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (void)dealloc {
	
}

- (void)postRequest {
	[self postRequestCustomizedWithSucceedBlock:NULL failedBlock:NULL];
}

- (void)postRequestCustomizedWithSucceedBlock:(ZPHttpRequestCompletedBlock)succeedBlock failedBlock:(ZPHttpRequestCompletedBlock)failedBlock {
	if ([RKObjectManager sharedManager].HTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
		ZPLogError(@"will not send request whithout network connection. %@", [self class]);
		NSString *message = ZPLocalizedString(@"No network connection. Please try later again.");
		ZPBaseDataModel *result = [ZPBaseDataModel modelWithError:[NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:@{NSLocalizedDescriptionKey:message}]];
		ZPInvokeBlock(failedBlock, result);
		return;
	}
	
	if (([self requestControl] == ZPRequestControlLoginRequired) && ![self hasLogin]) {
		ZPLogError(@"will not send loginOnly request whithout logged in. %@", [self class]);
		ZPBaseDataModel *result = [ZPBaseDataModel modelWithError:[NSError errorWithDomain:ZPRESTfulDomain code:-100 userInfo:@{NSLocalizedDescriptionKey:ZPLocalizedString(@"login is required")}]];
		ZPInvokeBlock(failedBlock, result);
		return;
	}
	
	RKResponseDescriptor *descriptor = [self responseDescriptor];
	[[RKObjectManager sharedManager] addRequestDescriptor:[self requestDescriptor]];
	[[RKObjectManager sharedManager] addResponseDescriptor:descriptor];
	if (_baseUrl) {
		descriptor.baseURL = _baseUrl;
	}
	
	self.succeedBlock = succeedBlock;
	self.failedBlock = failedBlock;
	
	[[RKObjectManager sharedManager] enqueueObjectRequestOperation:[self requestOperation]];
}

- (void)cancelRequest {
	[_requestOperation cancel];
}

#pragma mark - private methods -
- (BOOL)hasLogin {
	return YES;
}

- (RKObjectRequestOperation *)_generateRequestOperation {
	RKObjectRequestOperation *operation = nil;
	NSDictionary *requestParams = [RKObjectParameterization parametersWithObject:self
															   requestDescriptor:[self requestDescriptor]
																		   error:nil];
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:requestParams];
	if (_multipartItem) {
		NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:self
																								method:RKRequestMethodPOST
																								  path:[[self class]requestPath]
																							parameters:parameters
																			 constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
																				 [formData appendPartWithFileData:self.multipartItem.data
																											 name:self.multipartItem.parameterName
																										 fileName:self.multipartItem.fileName
																										 mimeType:self.multipartItem.MIMEType];
																			 }];
		
		if ([[[self class] responseMapping] isKindOfClass:[RKEntityMapping class]]) {
			operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
		} else {
			operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:nil failure:nil];
		}
	}
	else {
		operation = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:self
																						  method:[self.class requestMethod]
																							path:[self.class requestPath]
																					  parameters:parameters];
	}
	if (_timeoutInterval != 0) {
		NSMutableURLRequest *request = (NSMutableURLRequest *)operation.HTTPRequestOperation.request;
		request.timeoutInterval = _timeoutInterval;
	}
	
	return operation;
}

- (RKObjectRequestOperation *)requestOperation {
	if (!_requestOperation) {
		_requestOperation = [self _generateRequestOperation];
		
		if (_baseUrl) {
			NSMutableURLRequest *request = (NSMutableURLRequest *)[[_requestOperation HTTPRequestOperation] request];
			request.URL = [NSURL URLWithString:[[self class] requestPath] relativeToURL:_baseUrl];
		}
		
		ZPHttpRequestCompletedBlock succeed = self.succeedBlock;
		ZPHttpRequestCompletedBlock failed = self.failedBlock;
		
		__block ZPBaseHttpRequest *blockSelf = self;
		[_requestOperation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
			id<ZPHttpResponseMappingProtocol> resultInfo = nil;
			
			if (result.array.count == 0) {
				resultInfo = [ZPBaseDataModel modelWithError:[NSError errorWithDomain:NSURLErrorDomain code:-101 userInfo:@{NSLocalizedDescriptionKey:ZPLocalizedString(@"http response nothing")}]];
				ZPInvokeBlock(failed, resultInfo);
				return;
			}
			
			resultInfo = [result.array firstObject];
			
			BOOL isSuccess = YES;
			if ([resultInfo respondsToSelector:@selector(responseStatus)] && [resultInfo responseStatus] != blockSelf.statusSuccessValue) {
				isSuccess = NO;
			}
			if (isSuccess) {
				[blockSelf onRequestSucceed:resultInfo];
				ZPInvokeBlock(succeed, resultInfo);
			}
			else {
				[blockSelf onRequestFailed:resultInfo];
				ZPInvokeBlock(failed, resultInfo);
			}
			blockSelf = nil;
		} failure: ^(RKObjectRequestOperation *operation, NSError *error) {
			ZPInvokeBlock(failed, [ZPBaseDataModel modelWithError:error]);
		}];
	}
	
	return _requestOperation;
}

#pragma mark - overwrite optional -
- (RKRequestDescriptor *)requestDescriptor {
	return [RKRequestDescriptor requestDescriptorWithMapping:[self.class requestMapping]
												 objectClass:self.class
												 rootKeyPath:nil
													  method:[self.class requestMethod]];
}

- (RKResponseDescriptor *)responseDescriptor {
	//    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(RKStatusCodeClassSuccessful, 400)];// code within range [200, 600] is mapped as success code
	NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
	
	return [RKResponseDescriptor responseDescriptorWithMapping:[self.class responseMappingCustomized]
														method:[self.class requestMethod]
												   pathPattern:[self.class requestPath]
													   keyPath:nil
												   statusCodes:statusCodes];
}

- (ZPRequestControl)requestControl {
	return ZPRequestControlLoginRequired;
}

+ (RKRequestMethod)requestMethod {
	return RKRequestMethodPOST;
}

- (void)onRequestSucceed:(id<ZPHttpResponseMappingProtocol>)result {
}

- (void)onRequestFailed:(id<ZPHttpResponseMappingProtocol>)result {
}

#pragma mark - overwrite required -
+ (NSString *)requestPath {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (RKObjectMapping *)requestMapping {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (NSString *)responsePath {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (RKMapping *)responseMapping {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

+ (RKMapping *)responseMappingCustomized {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

@end
