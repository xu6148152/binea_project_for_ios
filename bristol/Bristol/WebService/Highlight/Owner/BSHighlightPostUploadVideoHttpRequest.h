//
//  BSHighlightPostUploadVideoHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSHighlightPostDataModel.h"

@interface BSHighlightPostUploadVideoHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType clientId;

+ (instancetype)requestWithVideoFullPath:(NSString *)fullPath;

@end
