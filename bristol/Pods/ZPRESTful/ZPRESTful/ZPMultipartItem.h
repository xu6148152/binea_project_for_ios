//
//  ZPMultipartItem.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/24/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPMultipartItem : NSObject

@property (nonatomic, strong) NSString *parameterName;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, strong) NSData *data;

@end
