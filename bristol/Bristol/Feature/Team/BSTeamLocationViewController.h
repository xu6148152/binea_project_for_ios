//
//  BSTeamLocationViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@class BSMapAnnotation;

@protocol BSLocationViewControllerDelegate <NSObject>
- (void) didSelectMapAnnotation:(BSMapAnnotation *)mapAnnotation;
@end

@interface BSTeamLocationViewController : BSBaseViewController
@property (nonatomic) BSMapAnnotation *mapAnnotation;
@property (nonatomic, weak) id<BSLocationViewControllerDelegate> delegate;
@end
