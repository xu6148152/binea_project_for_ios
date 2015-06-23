//
//  ZPFacebookSharer.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/4/14.
//  Copyright (c) 2014 ZEPP Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPFacebookSharer : NSObject

+ (BOOL)isConnected;
+ (void)logout;

+ (void)connectWithSuccessHandler:(void (^) (NSString *accessToken))successHandler faildHandler:(ZPErrorBlock)faildHandler;

+ (void)shareImage:(UIImage *)image title:(NSString *)title description:(NSString *)description successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;
+ (void)shareVideoWithUrl:(NSURL *)url title:(NSString *)title description:(NSString *)description successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

@end
