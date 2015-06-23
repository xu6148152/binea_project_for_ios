//
//  ZPBaseDataManager.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPClient;
@class NSManagedObjectModel;

@interface ZPBaseDataManager : NSObject

+ (instancetype)sharedInstance;

+ (NSString *)dbStorePath; // default is sandbox/Documents/data.db
+ (NSString *)dbSeedPath; // default is nil

- (void)save;

// overwrite by sub class
- (void)setHeaderForHTTPClient:(AFHTTPClient *)HTTPClient;
- (NSManagedObjectModel *)managedObjectModel; // default is models merged in main bundle

@end
