//
//  ZPInstagramActivity.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 3/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPInstagramActivity.h"
#import "ZPMacros.h"
#import "NSURL+CorrectPath.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface ZPInstagramActivity ()
{
	UIImage *_image;
	NSURL *_videoUrl;
}

@end

@implementation ZPInstagramActivity

- (NSString *)_urlencodedWithString:(NSString *)string {
	return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

- (void)_switchToInstagramWithAssetUrl:(NSURL *)assetURL {
	NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@", [self _urlencodedWithString:assetURL.absoluteString], [self _urlencodedWithString:_content]]];
	[[UIApplication sharedApplication] openURL:instagramURL];

	[self activityDidFinish:YES];
}

- (void)_showError:(NSError *)error {
	if (error) {
		[[[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:ZPLocalizedString(@"Done") otherButtonTitles:nil] show];

		[self activityDidFinish:NO];
	}
}

+ (BOOL)isValidVideoWithPath:(NSString *)path {
	NSArray *videoExtensions = @[@"mp4", @"mov", @"m4v", @"mpg"];
	NSString *extension = [[path pathExtension] lowercaseString];

	return [[NSFileManager defaultManager] fileExistsAtPath:path] && [videoExtensions containsObject:extension];
}

- (NSString *)activityType {
	return @"com.zepplabs.activity.instagram";
}

- (NSString *)activityTitle {
	return @"Instagram";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"ZPActivityResources.bundle/Icon_Twitter.png"]; // TODO: image to be updated
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];

	if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
		return NO; // no instagram.
	}

	for (NSObject *item in activityItems) {
		if ([item isKindOfClass:[UIImage class]]) {
			_image = (UIImage *)item;
			return YES;
		}
		else if ([item isKindOfClass:[NSString class]] && [ZPInstagramActivity isValidVideoWithPath:(NSString *)item]) {
			_videoUrl = [NSURL fileURLWithPath:(NSString *)item];
			return YES;
		}
		else if ([item isKindOfClass:[NSURL class]]) {
			NSURL *url = (NSURL *)item;
			if ([ZPInstagramActivity isValidVideoWithPath:[url correctPath]]) {
				_videoUrl = url;
				return YES;
			}
		}
	}

	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
}

- (UIViewController *)activityViewController {
	return nil;
}

- (void)performActivity {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	if (_image) {
		[library writeImageToSavedPhotosAlbum:_image.CGImage metadata:nil completionBlock: ^(NSURL *assetURL, NSError *error) {
		    if (!error) {
		        [self _switchToInstagramWithAssetUrl:assetURL];
			}
		    else {
		        [self _showError:error];
			}
		}];
	}
	else if (_videoUrl) {
		[library writeVideoAtPathToSavedPhotosAlbum:_videoUrl completionBlock: ^(NSURL *assetURL, NSError *error) {
		    if (!error) {
		        [self _switchToInstagramWithAssetUrl:assetURL];
			}
		    else {
		        [self _showError:error];
			}
		}];
	}
}

@end
