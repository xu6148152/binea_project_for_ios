//
//  ZPEvernoteActivity.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 4/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPEvernoteActivity.h"

@implementation ZPEvernoteActivity

- (NSString *)activityType {
	return @"com.zepplabs.activity.evernote";
}

- (NSString *)activityTitle {
	return _title ?: @"Evernote";
}

- (UIImage *)activityImage {
	return [UIImage imageNamed:@"ZPActivityResources.bundle/Icon_Evernote.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
}

- (UIViewController *)activityViewController {
	return nil;
}

- (void)performActivity {
	[self activityDidFinish:YES];
	ZPInvokeBlock(self.performActivityBlock);
}

@end
