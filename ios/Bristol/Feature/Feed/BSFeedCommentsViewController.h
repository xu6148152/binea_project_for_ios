//
//  BSFeedCommentsViewController.h
//  Bristol
//
//  Created by Bo on 1/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"
#import "BSHighlightMO.h"

@interface BSFeedCommentsViewController : BSBaseViewController <UITableViewDataSource, UITableViewDelegate>

+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight showKeyboard:(BOOL)showKeyboard;

@end
