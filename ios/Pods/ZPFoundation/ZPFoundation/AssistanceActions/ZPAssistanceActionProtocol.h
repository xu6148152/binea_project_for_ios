//
//  ZPAssistanceActionProtocol.h
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZPAssistanceActionProtocol <NSObject>

@required
- (NSString *)name;
- (NSString *)statusBarTitle;

@end


@protocol ZPAssistanceSingleAction <ZPAssistanceActionProtocol>

@required
- (void)performAction;

@end


@protocol ZPAssistanceMultipleActions <ZPAssistanceActionProtocol>

@required
- (void)performActionWithNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;

@end
