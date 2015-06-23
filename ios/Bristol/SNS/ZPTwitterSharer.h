//
//  ZPTwitterSharer.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPTwitterSharer : NSObject

+ (BOOL)isConnected;

+ (void)connectWithSuccessHandler:(void (^) (NSString *authToken, NSString *authTokenSecret))successHandler faildHandler:(ZPErrorBlock)faildHandler;

// Twitter does not supports post video now: https://twittercommunity.com/t/twitter-video-support-in-rest-and-streaming-api/31258
// + (void)shareVideoWithFullPath:(NSString *)fullPath description:(NSString *)description successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;
+ (void)shareImage:(UIImage *)image description:(NSString *)description successHandler:(ZPDictionaryBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler;

@end
