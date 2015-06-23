//
//  BSTestViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTestViewController.h"
#import "ZPInstagramSharer.h"
#import "ZPTwitterSharer.h"
#import "ZPFacebookSharer.h"

#import "BSVideoTrimmerView.h"
#import "BSUIGlobal.h"
#import "PureLayout.h"

@interface BSTestViewController ()
{
	BSVideoTrimmerView *_videoTrimmerView;
}
@end

@implementation BSTestViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	_videoTrimmerView = [BSVideoTrimmerView videoTrimmerViewFromNib];
//	_videoTrimmerView.translatesAutoresizingMaskIntoConstraints = NO;
//	[self.view addSubview:_videoTrimmerView];
//	[_videoTrimmerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//	[_videoTrimmerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//	[_videoTrimmerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//	[_videoTrimmerView autoSetDimension:ALDimensionHeight toSize:210];
//	
//	AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"]]];
//	[_videoTrimmerView configNOEffectModeWithAsset:asset minVideoDuration:5 maxVideoDuration:18 selectedBeginTime:5 selectedEndTime:12 highlightTime:8];
//	[_videoTrimmerView setMultiplyViewWork:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSURL *)_videoUrl {
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"03_Car" ofType:@"mp4"]];
	return url;
}

- (UIImage *)_imageToShare {
	return [UIImage imageNamed:@"AppIcon60x60@3x.png"];
}

- (IBAction)btnShareImageToIGTapped:(id)sender {
	[ZPInstagramSharer shareImage:[self _imageToShare] content:@"aosijd asodifaj j" completion: ^(NSError *error) {
	}];
}

- (IBAction)btnShareVideoToIGTapped:(id)sender {
	[ZPInstagramSharer shareVideoWithUrl:[self _videoUrl] content:@"videos sdfhao aosiow @09uwu023" completion:^(NSError *error) {
		
	}];
}

- (IBAction)btnConnectToIGTapped:(id)sender {
	[ZPInstagramSharer connectWithShowInViewController:self successHandler:^(NSString *string) {
		ZPLogDebug(@"success:%@", string);
	} faildHandler:^(NSError *error) {
		ZPLogDebug(@"faild:%@", error);
	}];
}

- (IBAction)btnShareImageToTWTapped:(id)sender {
	[ZPTwitterSharer connectWithSuccessHandler: ^(NSString *authToken, NSString *authTokenSecret) {
	    [ZPTwitterSharer shareImage:[self _imageToShare] description:@"aosijd asodifaj j" successHandler: ^(NSDictionary *dic) {
		} faildHandler: ^(NSError *error) {
		}];
	} faildHandler: ^(NSError *error) {
	}];
}

- (IBAction)btnShareImageToFBTapped:(id)sender {
	[ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
		[ZPFacebookSharer shareImage:[self _imageToShare] title:@"title ajsf asldfj" description:@"desc siodfja" successHandler:^{
			ZPLogDebug(@"success: btnShareImageToFBTapped");
		} faildHandler:^(NSError *error) {
			ZPLogDebug(@"faild: btnShareImageToFBTapped: %@", error);
		}];
	} faildHandler:^(NSError *error) {
		
	}];
}

- (IBAction)btnShareVideoToFBTapped:(id)sender {
	[ZPFacebookSharer connectWithSuccessHandler:^(NSString *accessToken) {
		[ZPFacebookSharer shareVideoWithUrl:[self _videoUrl] title:@"title ajsf asldfj" description:@"desc siodfja" successHandler:^{
			
		} faildHandler:^(NSError *error) {
		}];
	} faildHandler:^(NSError *error) {
		
	}];
}

- (IBAction)btnActionSheet1Tapped:(id)sender {
	[BSUIGlobal showActionSheetTitle:nil isDestructive:NO actionTitle:ZPLocalizedString(@"Choose a Photo") actionHandler:^{
		ZPLogDebug(@"Choose a Photo");
	} additionalConstruction:^(BSUIActionSheet *actionSheet) {
		[actionSheet addButtonWithTitle:ZPLocalizedString(@"Take a Photo") isDestructive:NO handler: ^{
			ZPLogDebug(@"Take a Photo");
		}];
	}];
}

- (IBAction)btnActionSheet2Tapped:(id)sender {
	[BSUIGlobal showActionSheetTitle:ZPLocalizedString(@"I have found this wonderful free project (from github) to use for custom UIAlertView and action sheets. I was wondering if I end up using both these options, whether apple would reject my application? I have heard you cannot use private libraries. Does this classify as that?") isDestructive:YES actionTitle:ZPLocalizedString(@"Stop following") actionHandler:^{
		ZPLogDebug(@"Stop following");
	}];
}

@end
