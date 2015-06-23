//
//  ZPRandomInstanceForTestProtocol.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZPRandomInstanceForTestProtocol <NSObject>

@required
- (void)randomPropertiesForTest;
+ (instancetype)randomInstanceForTest;

@end
