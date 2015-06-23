//
//  BSSongDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSSongPlayingStatus) {
	BSSongPlayingStatusStop,
	BSSongPlayingStatusPause,
	BSSongPlayingStatusPlay
};

@interface BSSongDataModel : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign) BSSongPlayingStatus status;

+ (instancetype)songWithName:(NSString *)name url:(NSURL *)url;

@end
