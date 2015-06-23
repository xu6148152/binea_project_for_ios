//
//  ZPHttpResponseMappingProtocol.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/19/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@protocol ZPHttpResponseMappingProtocol <NSObject>

@optional
+ (NSDictionary *)responseMappingDictionary;
- (NSInteger)responseStatus;

@required
+ (RKMapping *)responseMapping;

@end
