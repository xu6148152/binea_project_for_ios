//
//  BSTopTenHelpMeTopView.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataModels.h"

@interface BSTopTenHelpMeTopView : UIView

+ (void)showWithUser:(BSUserMO *)user sport:(BSSportMO *)sport event:(BSEventMO *)event highlight:(BSHighlightMO *)highlight currentRank:(NSInteger)currentRank toptenChannelType:(BSToptenChannelType)toptenChannelType actionButtonShare:(BOOL)actionButtonShare actionButtonCallBack:(ZPVoidBlock)actionButtonCallBack;

@end
