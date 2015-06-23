//
//  ZPInstagramActivity.h
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 3/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPInstagramActivity : UIActivity

@property (nonatomic, strong) NSString *content;

+ (BOOL)isValidVideoWithPath:(NSString *)path;

@end
