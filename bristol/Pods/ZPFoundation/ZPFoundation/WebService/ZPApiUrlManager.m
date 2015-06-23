//
//  ZPApiUrlManager.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/20/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPApiUrlManager.h"
#import "ZPLog.h"
#import "GTMObjectSingleton.h"

static NSString *const kApiUrlFileName = @"ZeppApis";
static NSString *const kCurrentIndex = @"CurrentIndex";
static NSString *const kUrls = @"urls";
static NSString *const kUrlReleased = @"https://api.zepp.com/api/2";
static NSString *const kUrlDebugDefault = @"https://cint.zepp.com/api/2";

@implementation ZPApiUrlManager
{
	NSMutableDictionary *dicUrls;
	NSString *_apiUrlFilePath;
}

static ZPApiUrlManager *instance;

+ (instancetype)sharedInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[ZPApiUrlManager alloc] initWithDefault];
        });
    }
    
    return instance;
}

+ (void)initializeWithApiUrls:(NSArray *)allApiUrls currentApiUrlIndex:(NSUInteger)index {
    if (instance) {
        ZPLogWarning(@"ZPApiUrlManager instance has been created, call initializeWithApiUrls:currentApiUrlIndex: before call sharedInstance to create custom api urls.");
    } else {
        if (index >= allApiUrls.count)
            index = 0;
        
        instance = [[ZPApiUrlManager alloc] initWithApiUrls:allApiUrls currentApiUrlIndex:index];
    }
}

- (id)initWithDefault {
	self = [super init];
    if (self) {
        dicUrls = [[NSDictionary dictionaryWithContentsOfFile:[self _getApiUrlFilePath]] mutableCopy];
        
        if (!dicUrls) {
            NSArray *aryUrls;
            NSNumber *index;
#ifdef APPSTORE
            aryUrls = @[kUrlReleased];
            index = @(0);
#else
            aryUrls = @[kUrlReleased, kUrlDebugDefault];
            index = @([aryUrls indexOfObject:kUrlDebugDefault]);
#endif
            
            dicUrls = [@{ kCurrentIndex: index, kUrls: aryUrls } mutableCopy];
            [self _writeData];
        }
	}

	return self;
}

- (id)initWithApiUrls:(NSArray *)allApiUrls currentApiUrlIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        dicUrls = [[NSDictionary dictionaryWithContentsOfFile:[self _getApiUrlFilePath]] mutableCopy];
        
        if (!dicUrls) {
            dicUrls = [@{ kCurrentIndex: @(index), kUrls: allApiUrls } mutableCopy];
            [self _writeData];
        }
    }
    return self;
}

- (NSString *)_getApiUrlFilePath {
	if (!_apiUrlFilePath) {
		_apiUrlFilePath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
		if (![[NSFileManager defaultManager] fileExistsAtPath:_apiUrlFilePath]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:_apiUrlFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
		}
		_apiUrlFilePath = [_apiUrlFilePath stringByAppendingPathComponent:kApiUrlFileName];
	}

	return _apiUrlFilePath;
}

- (void)_writeData {
    BOOL success = [dicUrls writeToFile:[self _getApiUrlFilePath] atomically:YES];
    if (!success) {
        ZPLogError(@"Failed to create default api url file");
    }
}

- (NSArray *)allApiUrls {
	return [dicUrls[kUrls] copy];
}

- (NSURL *)currentApiUrl {
	NSArray *aryUrls = dicUrls[kUrls];

	if (aryUrls.count == 0) {
		return [NSURL URLWithString:kUrlReleased];
	}

	NSUInteger index = [dicUrls[kCurrentIndex] unsignedIntegerValue];

	if (index > aryUrls.count) {
		index = 0;
	}

	NSString *urlString = aryUrls[index];
	return [NSURL URLWithString:urlString];
}

- (NSString *)currentApiUrlString {
	return [self currentApiUrl].absoluteString;
}

- (void)setCurrentApiUrlAtIndex:(NSUInteger)index {
	NSArray *aryUrls = dicUrls[kUrls];
	if (index < aryUrls.count && [dicUrls[kCurrentIndex] integerValue] != index) {
		dicUrls[kCurrentIndex] = @(index);
		[self _writeData];

		[[NSNotificationCenter defaultCenter] postNotificationName:ZPApiUrlDidChangedNotification object:self];
	}
}

- (BOOL)isReleaseModeForUrlString:(NSString *)urlString {
	return [urlString isEqualToString:kUrlReleased];
}

@end
