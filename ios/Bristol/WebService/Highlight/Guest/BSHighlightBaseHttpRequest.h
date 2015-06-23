//
//  BSHighlightBaseHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSHighlightBaseHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType highlightId;

+ (instancetype)requestWithHighlightId:(DataModelIdType)highlightId;

@end
