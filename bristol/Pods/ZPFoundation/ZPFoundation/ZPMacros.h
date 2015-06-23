//
//  ZPMacros.h
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/11/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#ifndef ZPFoundation_ZPMacros_h
#define ZPFoundation_ZPMacros_h

#import <UIKit/UIKit.h>

// UIKit
#define UIViewAutoresizingFlexibleAll (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin)

#define kIsPadUI (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIsPhoneUI (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kDefaultAnimateDuration .25

// localization
#define ZPLocalizedString(str) NSLocalizedString(str, str)

// blocks
#define ZPInvokeBlock(block, ...) \
if (block)                    \
block(__VA_ARGS__)

#define dispatch_main_sync_safe(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_sync(dispatch_get_main_queue(), block); \
}

#define dispatch_main_async_safe(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_async(dispatch_get_main_queue(), block); \
}

typedef void (^ZPDictionaryBlock) (NSDictionary *dictionary);
typedef void (^ZPArrayBlock) (NSArray *array);
typedef void (^ZPNumberBlock) (NSNumber *number);
typedef void (^ZPStringBlock) (NSString *string);
typedef void (^ZPErrorBlock) (NSError *error);
typedef void (^ZPDataBlock) (NSData *data);
typedef void (^ZPImageBlock) (UIImage *image);
typedef void (^ZPVoidBlock) (void);
typedef void (^ZPBOOLBlock) (BOOL flag);


#endif
