//
//  BSAccountTermsOfServiceViewController.m
//  Bristol
//
//  Created by Bo on 15/5/26.
//  Copyright (c) 2015年 Zepp US Inc. All rights reserved.
//

#import "BSAccountTermsOfServiceViewController.h"

@implementation BSAccountTermsOfServiceViewController


+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountTermsOfServiceViewController"];
}

- (IBAction)btnDismissTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
