//
//  ZPEvernoteActivity.h
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 4/7/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPMacros.h"

@interface ZPEvernoteActivity : UIActivity

@property (nonatomic, strong) ZPVoidBlock performActivityBlock;
@property (nonatomic, strong) NSString *title;

@end
