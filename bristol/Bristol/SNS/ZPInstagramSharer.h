//
//  ZPInstagramSharer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZPInstagramResponseType) {
	ZPInstagramResponseTypeCode,
	ZPInstagramResponseTypeAccessToken
};

@interface ZPInstagramSharer : NSObject

+ (BOOL)isInstalled;

+ (void)clearToken;
+ (BOOL)isConnected;

// ZPInstagramResponseTypeCode
+ (void)connectWithShowInViewController:(UIViewController *)vc successHandler:(ZPStringBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;
+ (void)connectWithShowInViewController:(UIViewController *)vc type:(ZPInstagramResponseType)type successHandler:(ZPStringBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

+ (void)shareImage:(UIImage *)image content:(NSString *)content completion:(ZPErrorBlock)completion;
+ (void)shareVideoWithUrl:(NSURL *)url content:(NSString *)content completion:(ZPErrorBlock)completion;

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

@end
