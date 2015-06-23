//
//  BSAccountGetStartedViewController.m
//  Bristol
//
//  Created by Bo on 3/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountGetStartedViewController.h"
#import "BSAccountLoginViewController.h"

@interface BSAccountGetStartedViewController ()

@end

@implementation BSAccountGetStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountGetStartedViewController"];
}

+ (UINavigationController *)instanceNavigationControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountGetStartedViewControllerNav"];
}

- (IBAction)tapLoginBtn:(id)sender {
    BSAccountLoginViewController *vc = [BSAccountLoginViewController instanceFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
