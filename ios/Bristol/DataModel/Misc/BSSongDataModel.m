//
//  BSSongDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSSongDataModel.h"

@implementation BSSongDataModel

+ (instancetype)songWithName:(NSString *)name url:(NSURL *)url {
    return [[BSSongDataModel alloc] initWithName:name url:url];
}

- (instancetype)initWithName:(NSString *)name url:(NSURL *)url {
    if (self = [super init]) {
        _name = name;
        _url = url;
    }
    return self;
}

@end
