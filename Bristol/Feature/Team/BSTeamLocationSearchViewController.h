//
//  BSTeamLocationSearchViewController.h
//  Bristol
//
//  Created by Yangfan Huang on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"

@protocol BSTeamLocationSearchViewControllerDelegate <NSObject>
- (void) didSelectLocationName:(NSString *)locationName latitude:(float)latitude longitude:(float)longitude;
@end

@interface BSTeamLocationSearchViewController : BSBaseViewController
@property (nonatomic, weak) id<BSTeamLocationSearchViewControllerDelegate> delegate;
@end
