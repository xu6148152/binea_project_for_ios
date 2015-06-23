//
//  ZPInstagramSharer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPInstagramSharer.h"
#import "FXKeychain.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface ZPInstagramConnectViewController : UIViewController

@property(nonatomic, assign) ZPInstagramResponseType type;

@end

static NSString *kInstagramClientId = @"7cb66b8e1cdf433d9e61b90cc4db8f2e";
static NSString *kRedirectUri = @"https://bristol-test.zepp.com/api/b1/oauth/instagram-callback";
static NSString *kScope = @"basic"; // http://instagram.com/developer/authentication/#scope


@interface ZPInstagramConnectViewController () <UIWebViewDelegate>
{
	NSError *_error;
}
@property (strong, nonatomic) ZPStringBlock successHandler;
@property (strong, nonatomic) ZPErrorBlock faildHandler;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;

@end

@implementation ZPInstagramConnectViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"ZPSNS" bundle:nil] instantiateViewControllerWithIdentifier:@"ZPInstagramConnectViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"ZPSNS" bundle:nil] instantiateViewControllerWithIdentifier:@"ZPInstagramConnectViewControllerNav"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = ZPLocalizedString(@"Login to Instagram");
	[_btnRetry setTitle:ZPLocalizedString(@"Retry") forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
	
	_webView.scrollView.bounces = NO;
	[self _loadRequest];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)_loadRequest {
	_errorView.hidden = YES;
	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=%@&scope=%@", kInstagramClientId, kRedirectUri, _type == ZPInstagramResponseTypeCode ? @"code" : @"token", kScope]];
	_webView.delegate = self;
	[_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)_showError:(NSError *)error {
	_error = error;
	
	_errorView.hidden = NO;
	_activityIndicator.hidden = YES;
	[_activityIndicator stopAnimating];
	
	_lblErrorMessage.text = error.localizedDescription;
}

- (BOOL)_checkCanShowError:(NSError *)error {
	if (error) {
		dispatch_main_async_safe( ^{
			[self _showError:error];
		});
		return YES;
	}
	else
		return NO;
}

- (IBAction)btnCancelTapped:(id)sender {
	[_webView stopLoading];
	ZPInvokeBlock(self.faildHandler, _error);
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnRetryTapped:(id)sender {
	[self _loadRequest];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *URLString = [request.URL absoluteString];
	if ([URLString hasPrefix:kRedirectUri]) {
		NSString *delimiter = _type == ZPInstagramResponseTypeCode ? @"code=" : @"access_token=";
		NSArray *components = [URLString componentsSeparatedByString:delimiter];
		if (components.count > 1) {
			[self dismissViewControllerAnimated:YES completion:NULL];
			
			NSString *code = [components lastObject];
			ZPInvokeBlock(self.successHandler, code);
		}
		return NO;
	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if (error.code != 102) {
		[self _showError:error];
	}
}

@end

#define kIGToken @"kIGToken"
#define kIGId @"kIGId"
#pragma mark - ZPInstagramSharer
@implementation ZPInstagramSharer

+ (BOOL)isInstalled {
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
	return [[UIApplication sharedApplication] canOpenURL:instagramURL];
}

+ (NSString *)_token {
	NSString *token = [FXKeychain defaultKeychain][kIGToken];
	return token;
}

+ (void)clearToken {
	[FXKeychain defaultKeychain][kIGToken] = nil;
	[FXKeychain defaultKeychain][kIGId] = nil;
}

+ (BOOL)isConnected {
	NSString *token = [ZPInstagramSharer _token];
	ZPLogDebug(@"isConnected: %@", token ? @"Y" : @"N");
	return token != nil;
}

+ (void)connectWithShowInViewController:(UIViewController *)vc type:(ZPInstagramResponseType)type successHandler:(ZPStringBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (vc) {
		UINavigationController *navVC = [ZPInstagramConnectViewController instanceNavigationControllerFromStoryboard];
		ZPInstagramConnectViewController *webVC = (ZPInstagramConnectViewController *)[navVC topViewController];
		webVC.type = type;
		webVC.successHandler = ^(NSString *authToken) {
			[FXKeychain defaultKeychain][kIGToken] = authToken;
			ZPInvokeBlock(successHandler, authToken);
		};
		webVC.faildHandler = faildHandler;
		
		[vc presentViewController:navVC animated:YES completion:NULL];
	}
}

+ (void)connectWithShowInViewController:(UIViewController *)vc successHandler:(ZPStringBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	[ZPInstagramSharer connectWithShowInViewController:vc type:ZPInstagramResponseTypeCode successHandler:successHandler faildHandler:faildHandler];
}

+ (NSString *)_urlencodedWithString:(NSString *)string {
	return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

+ (void)_switchToInstagramWithAssetUrl:(NSURL *)assetURL content:(NSString *)content {
	if (!content) {
		content = @"";
	}
	NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@", [self _urlencodedWithString:assetURL.absoluteString], [self _urlencodedWithString:content]]];
	[[UIApplication sharedApplication] openURL:instagramURL];
}

+ (void)shareImage:(UIImage *)image content:(NSString *)content completion:(ZPErrorBlock)completion {
	if (!image || ![ZPInstagramSharer isInstalled]) {
		return;
	}
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock: ^(NSURL *assetURL, NSError *error) {
		if (!error) {
			[ZPInstagramSharer _switchToInstagramWithAssetUrl:assetURL content:content];
			ZPInvokeBlock(completion, nil);
		}
		else {
			ZPInvokeBlock(completion, error);
		}
	}];
}

+ (void)shareVideoWithUrl:(NSURL *)url content:(NSString *)content completion:(ZPErrorBlock)completion {
	if (!url || ![ZPInstagramSharer isInstalled]) {
		return;
	}
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeVideoAtPathToSavedPhotosAlbum:url completionBlock: ^(NSURL *assetURL, NSError *error) {
		if (!error) {
			[ZPInstagramSharer _switchToInstagramWithAssetUrl:assetURL content:content];
			ZPInvokeBlock(completion, nil);
		}
		else {
			ZPInvokeBlock(completion, error);
		}
	}];
}

+ (void)getFriendsIdWithSuccessHandler:(ZPArrayBlock)successHandler faildHandler:(ZPErrorBlock)faildHandler {
	if (![ZPInstagramSharer isConnected]) {
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		ZPVoidBlock getFriends = ^ {
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows?access_token=%@", [FXKeychain defaultKeychain][kIGId], [ZPInstagramSharer _token]]];
			NSError *err = nil;
			NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&err];
			if (err) {
				ZPInvokeBlock(faildHandler, err);
			} else {
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
				if (err) {
					ZPInvokeBlock(faildHandler, err);
				} else {
					NSMutableArray *ids = [NSMutableArray array];
					for (NSDictionary *dicUsers in dic[@"data"]) {
						[ids addObject:dicUsers[@"id"]];
					}
					
					ZPInvokeBlock(successHandler, ids);
				}
			}
			[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
		};
		
		[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
		
		NSString *igId = [FXKeychain defaultKeychain][kIGId];
		if (igId) {
			getFriends();
		} else {
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@", [ZPInstagramSharer _token]]];
			NSError *err = nil;
			NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&err];
			if (err) {
				[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
				
				ZPInvokeBlock(faildHandler, err);
			} else {
				NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
				if (err) {
					[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
					
					ZPInvokeBlock(faildHandler, err);
				} else {
					[FXKeychain defaultKeychain][kIGId] = dic[@"data"][@"id"];
					
					getFriends();
				}
			}
		}
	});
}

@end
