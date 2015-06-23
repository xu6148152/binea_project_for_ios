//
//  BSBaseButton.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/2/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSUIGlobal.h"

@interface BSBaseButton : UIButton

@property(nonatomic, strong, readonly) UIImage *imageDesignedOfNormal;
@property(nonatomic, strong, readonly) UIImage *imageDesignedOfHighlighted;
@property(nonatomic, strong, readonly) UIImage *imageDesignedOfSelected;
@property(nonatomic, strong, readonly) UIImage *imageDesignedOfDisabled;

@end
