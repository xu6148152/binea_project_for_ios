//
//  BSHighlightButton.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseButton.h"

@class BSHighlightMO;
@class BSNotificationMO;
@interface BSHighlightButton : BSBaseButton

- (void)configWithHighlight:(BSHighlightMO *)highlight;
- (void)configWithHighlight:(BSHighlightMO *)highlight completion:(ZPImageBlock)completion;

- (void)configWithHighlight:(BSHighlightMO *)highlight notification:(BSNotificationMO *)notification;

@end
