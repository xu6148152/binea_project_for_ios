//
//  BSCapturePostViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"
#import "BSActivityIndicatorButton.h"

typedef void (^BSButtonBlock) (UIButton *button);

@interface BSCapturePostViewController : BSBaseViewController

@property (nonatomic, strong) BSSportMO *sportSelected;
@property (weak, nonatomic) IBOutlet BSActivityIndicatorButton *btnShareWithFB;
@property (weak, nonatomic) IBOutlet BSActivityIndicatorButton *btnShareWithTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnShareWithIG;

@property (nonatomic, copy) BSButtonBlock postButtonTappedBlock;
@property (nonatomic, copy) ZPVoidBlock backButtonTappedBlock;

@end
