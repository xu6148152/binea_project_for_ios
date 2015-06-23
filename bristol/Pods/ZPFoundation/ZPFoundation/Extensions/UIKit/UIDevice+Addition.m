//
//  UIDevice+Addition.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/24/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "UIDevice+Addition.h"
#import <sys/utsname.h>

@implementation UIDevice (Addition)

// NOTE: duplicate with ZPVideoCapturer _freeDiskSpaceInBytes
+ (CGFloat)freeDiskSpaceInBytes {
    CGFloat freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    static const long long SpaceCalibarate = 200 * 1024 * 1024; // 200MB, refer to http://stackoverflow.com/questions/9270027/iphone-free-space-left-on-device-reported-incorrectly-200-mb-difference
    if (freeSpace > SpaceCalibarate)
        freeSpace -= SpaceCalibarate;
    else
        freeSpace = 0;
    
    return freeSpace;
}

@end
