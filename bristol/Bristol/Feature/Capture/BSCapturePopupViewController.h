//
//  BSCapturePopupViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/18/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@interface BSCapturePopupViewController : BSBaseViewController

+ (BOOL)ifCanShowTimelineInstruction;
+ (void)showTimelineInstructionWithCompletion:(ZPVoidBlock)completion;

+ (BOOL)ifCanShowNOEffectInstruction;
+ (void)showNOEffectInstructionWithArrowPointInWindowCoordinate:(CGPoint)arrowPoint;

+ (BOOL)ifCanShowEffectInstruction;
+ (void)showEffectInstructionWithArrowPointInWindowCoordinate:(CGPoint)arrowPoint;

@end
