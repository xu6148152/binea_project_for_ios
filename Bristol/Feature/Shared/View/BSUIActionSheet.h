//
//  BSUIActionSheet.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSUIActionSheet : UIView

+ (id)actionSheetWithTitle:(NSString *)title;

- (NSInteger)addButtonWithTitle:(NSString *)title isDestructive:(BOOL)isDestructive handler:(ZPVoidBlock)handler;
- (void)showInView:(UIView *)view;

@end
