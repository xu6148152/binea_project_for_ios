//
//  ZPUIGlobal.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/5/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUIActionSheet.h"

static const NSTimeInterval kDefaultHideHudDelay = 1;

@interface BSUIGlobal : NSObject

+ (void) setDarkHUD:(BOOL)dark;

+ (MBProgressHUD *)showLoadingWithMessage:(NSString *)message;
+ (void)hideLoading;

+ (void)showError:(NSError *)error;
+ (void)showMessage:(NSString *)message;

+ (void)showAlertMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(ZPVoidBlock)cancelHandler actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler;
+ (void)showAlertMessage:(NSString *)message actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler;

+ (void)showActionSheetTitle:(NSString *)title isDestructive:(BOOL)isDestructive actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler additionalConstruction:(void (^)(BSUIActionSheet *actionSheet))additionalConstruction;
+ (void)showActionSheetTitle:(NSString *)title isDestructive:(BOOL)isDestructive actionTitle:(NSString *)actionTitle actionHandler:(ZPVoidBlock)actionHandler;

+ (void)showImagePickerControllerInViewController:(UIViewController *)viewController additionalConstruction:(void (^)(UIImagePickerController *picker))additionalConstruction didFinishPickingMedia:(void (^)(NSDictionary *info))didFinishPickingMedia didCancel:(ZPVoidBlock)didCancel;

+ (UILabel *)createCommonTableViewSectionHeaderWithTitle:(NSString *)title;

// colors
+ (UIColor *)alertColor; // #EB4747
+ (UIColor *)placeholderColor; // #D1D1D1
+ (UIColor *)positiveColor; // #C7E200
+ (UIColor *)negativeColor; // #D73E1D
+ (UIColor *)multiplyBlendColor;
+ (UIColor *)appBGColor;
+ (UIColor *)tableViewCellColor;

+ (UIImage *)placeholderImage;

+ (UIWindow *)appWindow;
@end
