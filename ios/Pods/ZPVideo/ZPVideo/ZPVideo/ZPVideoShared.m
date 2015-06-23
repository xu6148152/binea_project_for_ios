//
//  ZPVideo.h
//  ZPVideo
//
//  Created by Guichao Huang (Gary) on 10/5/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPVideoShared.h"

@implementation ZPVideoShared

// Set Logging Component
#undef ZPLogComponent
#define ZPLogComponent lcl_cVideo

+ (NSString *)getVideoTmpPath {
	NSString *path = NSTemporaryDirectory();
	path = [path stringByAppendingPathComponent:@"videoTmp"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
	}

	return path;
}

+ (NSURL *)generateRandomTempFile {
	NSString *path = [self getVideoTmpPath];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	NSString *dateTimePrefix = [formatter stringFromDate:[NSDate date]];
	NSString *fullPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%i.mov", dateTimePrefix, arc4random() % 100000]];

	return [NSURL fileURLWithPath:fullPath];
}

@end
