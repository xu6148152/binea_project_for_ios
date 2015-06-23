//
//  ZPFacebookSharer.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 9/4/14.
//  Copyright (c) 2014 ZEPP Inc. All rights reserved.
//

#import "ZPFacebookSharer.h"
#import "BSHttpResponseDataModel.h"
#import "BSSignInWithFacebookHttpRequest.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation ZPFacebookSharer

+ (BOOL)isConnected {
	BOOL isSessionOpen = FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
	ZPLogDebug(@"isConnected: %@", isSessionOpen ? @"Y" : @"N");
	return isSessionOpen;
}

+ (void)logout {
	[FBSession.activeSession closeAndClearTokenInformation];
}

+ (NSArray *)_getPermissions {
	return @[@"public_profile", @"email", @"publish_actions", @"user_friends"];
}

+ (void)connectWithSuccessHandler:(void (^) (NSString *accessToken))successHandler faildHandler:(ZPErrorBlock)faildHandler {
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	[FBSession openActiveSessionWithPublishPermissions:[self _getPermissions] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
	    switch (status) {
			case FBSessionStateOpen:
			case FBSessionStateOpenTokenExtended:
				{
				    ZPInvokeBlock(successHandler, session.accessTokenData.accessToken);
				    break;
				}

			case FBSessionStateClosedLoginFailed:
			default:
				{
				    ZPInvokeBlock(faildHandler, error);
				    break;
				}
		}
	}];
}

+ (void)_shareData:(NSData *)data title:(NSString *)title description:(NSString *)description graphPath:(NSString *)graphPath successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (!title) {
		title = @"";
	}
	if (!description) {
		description = @"";
	}
	NSDictionary *params = @{ @"title" : title,
							  @"description" : description,
							  @"video.mp4" : data,
							  @"contentType" : @"video/mp4"};
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	[FBRequestConnection startWithGraphPath:graphPath parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
		if (!error) {
			ZPInvokeBlock(successHandler);
		}
		else {
			ZPInvokeBlock(faildHandler, error);
		}
	}];
}

+ (void)shareImage:(UIImage *)image title:(NSString *)title description:(NSString *)description successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (!image || ![ZPFacebookSharer isConnected]) {
		return;
	}
	
	NSData *data = UIImageJPEGRepresentation(image, 0.9);
	[ZPFacebookSharer _shareData:data title:title description:description graphPath:@"me/photos" successHandler:successHandler faildHandler:faildHandler];
}

+ (void)shareVideoWithUrl:(NSURL *)url title:(NSString *)title description:(NSString *)description successHandler:(ZPVoidBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	NSData *data = [NSData dataWithContentsOfFile:url.correctPath];
	if (!data || ![ZPFacebookSharer isConnected]) {
		return;
	}

	[ZPFacebookSharer _shareData:data title:title description:description graphPath:@"me/videos" successHandler:successHandler faildHandler:faildHandler];
}

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	[FBRequestConnection startWithGraphPath:@"/me/friends" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error) {
		[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		
		if (!error) {
			NSArray *friends = result[@"data"];
			NSMutableArray *ids = [NSMutableArray array];
			for (NSDictionary<FBGraphUser> *friend in friends) {
				[ids addObject:friend.objectID];
			}
			ZPInvokeBlock(successHandler, ids);
		}
		else {
			ZPInvokeBlock(faildHandler, error);
		}
	}];
}

@end
