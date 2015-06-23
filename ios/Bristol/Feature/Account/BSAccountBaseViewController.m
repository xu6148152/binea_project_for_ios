//
//  BSAccountBaseViewController.m
//  Bristol
//
//  Created by Gary Wong on 5/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountBaseViewController.h"

@interface BSAccountBaseViewController ()

@end

@implementation BSAccountBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [BSUIGlobal setDarkHUD:YES];
}

@end
