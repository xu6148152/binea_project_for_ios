//
//  ZPBaseViewController.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/3/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "PureLayout.h"

#import "BSDataManager.h"
#import "BSUIGlobal.h"
#import "UITableView+GlobalUI.h"

#import "BSEventTracker.h"

@interface UIViewController (InstanceFromStoryboard)

+ (instancetype)instanceFromStoryboard;
+ (UINavigationController *)instanceNavigationControllerFromStoryboard;

- (void)adjustScrollViewInsets:(UIScrollView *)scrollView;

@end


@interface BSBaseViewController : UIViewController<BSEventTrackPageProtocol>
@property (nonatomic) NSString *useCase;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSDictionary *pageViewProperties;
@end

@interface BSBaseTableViewController : UITableViewController<BSEventTrackPageProtocol>
@property (nonatomic) NSString *useCase;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSDictionary *pageViewProperties;
@end


@interface BSTabbarBaseViewController : UIViewController <UIGestureRecognizerDelegate, BSEventTrackPageProtocol>
@property (nonatomic) NSString *useCase;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSDictionary *pageViewProperties;
@end

@interface BSTabbarBaseTableViewController : UITableViewController <UIGestureRecognizerDelegate, BSEventTrackPageProtocol>
@property (nonatomic) NSString *useCase;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSDictionary *pageViewProperties;
@end
