//
//  BSHighlightPostUploadVideoHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightPostUploadVideoHttpRequest.h"

@implementation BSHighlightPostUploadVideoHttpRequest

+ (instancetype)requestWithVideoFullPath:(NSString *)fullPath {
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    if (!data) {
        return nil;
    }
    
	BSHighlightPostUploadVideoHttpRequest *request = BSHighlightPostUploadVideoHttpRequest.alloc.init;

	ZPMultipartItem *multipartItem = ZPMultipartItem.alloc.init;
	multipartItem.fileName = [fullPath lastPathComponent];
	multipartItem.parameterName = @"file";
	multipartItem.MIMEType = @"application/mp4";
	multipartItem.data = data;
	request.multipartItem = multipartItem;

	return request;
}

#pragma mark - overwrite -
+ (NSString *)requestPath {
	return @"highlights/background_upload";
}

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"clientId" : @"client_id",
	 }];
	return mapping;
}

+ (NSString *)responsePath {
    return nil;
}

+ (RKMapping *)responseMapping {
    return [BSHighlightPostDataModel responseMapping];
}

@end
