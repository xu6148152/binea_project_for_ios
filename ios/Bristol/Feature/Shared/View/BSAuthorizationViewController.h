//
//  BSAuthorizationViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/23/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BSAuthorizationType) {
	BSAuthorizationTypeCamera,
	BSAuthorizationTypePhotos,
	BSAuthorizationTypeMicrophone,
	BSAuthorizationTypeLocation
};

@interface BSAuthorizationViewController : UIViewController

+ (instancetype)instanceFromDefaultNibWithType:(BSAuthorizationType)type;
- (void)showInViewController:(UIViewController *)viewController dismissCompletion:(ZPVoidBlock)dismissCompletion;

@end
