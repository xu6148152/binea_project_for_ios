//
//  ZPTwitterSharer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPTwitterSharer.h"
#import "BSSignInWithTwitterHttpRequest.h"
#import "BSDataModels.h"

#import <TwitterKit/TwitterKit.h>

@implementation ZPTwitterSharer

+ (BOOL)isConnected {
	BOOL isSessionOpen = [Twitter sharedInstance].session != nil;
	ZPLogDebug(@"isConnected: %@", isSessionOpen ? @"Y" : @"N");
	return isSessionOpen;
}

+ (void)connectWithSuccessHandler:(void (^) (NSString *authToken, NSString *authTokenSecret))successHandler faildHandler:(ZPErrorBlock)faildHandler {
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	[[Twitter sharedInstance] logInWithCompletion: ^(TWTRSession *session, NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
	    if (session) {
	        ZPInvokeBlock(successHandler, session.authToken, session.authTokenSecret);
		}
	    else {
	        ZPInvokeBlock(faildHandler, error);
		}
	}];
}

// api: https://dev.twitter.com/rest/reference/post/statuses/update
+ (void)shareImage:(UIImage *)image description:(NSString *)description successHandler:(ZPDictionaryBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (!image || ![ZPTwitterSharer isConnected]) {
		return;
	}
	if (!description) {
		description = @"";
	}

	NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
	NSString *imageString = [imageData base64EncodedStringWithOptions:0];
	
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
	NSURLRequest *request = [APIClient URLRequestWithMethod:@"POST" URL:@"https://upload.twitter.com/1.1/media/upload.json" parameters:@{ @"media":imageString } error:nil];
	[APIClient sendTwitterRequest:request completion: ^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
		if (data && !error) {
			NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
			NSString *media_id = dic[@"media_id_string"];
			NSMutableDictionary *params = [@{ @"status":description, @"wrap_links":@"true" } mutableCopy];
			if (media_id) {
				params[@"media_ids"] = media_id;
			}
			
			NSURLRequest *request = [APIClient URLRequestWithMethod:@"POST" URL:@"https://api.twitter.com/1.1/statuses/update.json" parameters:params error:nil];
			[APIClient sendTwitterRequest:request completion: ^(NSURLResponse *response, NSData *data, NSError *error) {
				if (error) {
					ZPInvokeBlock(faildHandler, error);
				}
				else {
					NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
					ZPInvokeBlock(successHandler, dic);
				}
			}];
		} else {
			ZPInvokeBlock(faildHandler, error);
		}
	}];
}

+ (void)_actuallyGetFriendsIdWithCursor:(NSString *)cursor friendsId:(NSMutableArray *)friendsId successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (!cursor) {
		cursor = @"-1";
	}
	
	TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
	NSURLRequest *request = [APIClient URLRequestWithMethod:@"GET" URL:@"https://api.twitter.com/1.1/friends/list.json" parameters:@{ @"count":@"200", @"user_id" : [Twitter sharedInstance].session.userID, @"cursor" : cursor} error:nil];
	[APIClient sendTwitterRequest:request completion: ^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
		if (data && !error) {
			NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
			NSArray *users = dic[@"users"];
			for (NSDictionary *dicUser in users) {
				NSString *idStr = dicUser[@"id"];
				[friendsId addObject:idStr];
			}
			
			NSString *next_cursor = dic[@"next_cursor_str"];
			if (![next_cursor isEqualToString:@"0"]) {
				[ZPTwitterSharer _actuallyGetFriendsIdWithCursor:next_cursor friendsId:friendsId successHandler:successHandler faildHandler:faildHandler];
			} else {
				ZPInvokeBlock(successHandler);
			}
		} else {
			ZPInvokeBlock(faildHandler, error);
		}
	}];
}

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (![ZPTwitterSharer isConnected]) {
		return;
	}
	
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	NSMutableArray *friendsId = [NSMutableArray array];
	[ZPTwitterSharer _actuallyGetFriendsIdWithCursor:nil friendsId:friendsId successHandler:^{
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
		ZPInvokeBlock(successHandler, friendsId);
	} faildHandler:^(NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
		ZPInvokeBlock(faildHandler, error);
	}];
}

@end
