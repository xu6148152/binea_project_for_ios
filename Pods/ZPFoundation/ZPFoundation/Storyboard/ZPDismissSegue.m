//
//  ZPDismissSegue.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 12/14/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPDismissSegue.h"

@implementation ZPDismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
