//
//  NSURL+CorrectPath.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "NSURL+CorrectPath.h"

@implementation NSURL (CorrectPath)

- (NSString *)correctPath {
    NSString *path = self.isFileURL ? self.path : self.absoluteString;
    return path;
}

@end
