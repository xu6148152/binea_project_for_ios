//
//  BSFeedCheckHttpRequest.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSNewFeedDataModel.h"

@interface BSFeedCheckHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType lastHighlightId;

@end
