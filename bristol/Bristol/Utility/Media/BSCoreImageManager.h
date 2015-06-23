//
//  BSCoreImageManager.h
//  AVFoundationEditor
//
//  Created by Guichao Huang (Gary) on 4/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

typedef NS_ENUM(NSUInteger, BSCoreImageFilter) {
	BSCoreImageFilterNone = 0,
	BSCoreImageFilterGray = 1 << 0,
	BSCoreImageFilterBlur = 1 << 1,
};

@interface BSCoreImageManager : NSObject

@property (nonatomic, strong, readonly) EAGLContext *eaglContext;
@property (nonatomic, strong, readonly) CIContext *ciContext;

+ (instancetype)sharedManager;

- (UIImage *)createUIImageFromCIImage:(CIImage *)ciimage;

- (UIImage *)filterImage:(UIImage *)image withFilter:(BSCoreImageFilter)filter;

- (UIImage *)multiplyBlendImage:(UIImage *)image withColor:(UIColor *)color frameNormalized:(CGRect)frameNormalized;
- (UIImage *)multiplyBlendImage:(UIImage *)image; // color:[BSUIGlobal multiplyBlendColor], frameNormalized:CGRectMake(0, 0, 1, 1)
- (UIImage *)multiplyBlendImage:(UIImage *)image frameNormalized:(CGRect)frameNormalized; // color:[BSUIGlobal multiplyBlendColor]

- (void)generateImageForVideoUrl:(NSURL *)url size:(CGSize)size withFilter:(BSCoreImageFilter)filter atTimes:(NSArray *)times completion:(void (^)(NSArray *images))completion; // array of NSNumbers with NSTimeInterval

@end
