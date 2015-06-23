//
//  BSTeamEventHighlightCollectionViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightLoadingMoreCollectionViewDataSource.h"
#import "BSTeamMO.h"
#import "BSEventMO.h"

@interface BSTeamEventHighlightCollectionViewDataSource : BSHighlightLoadingMoreCollectionViewDataSource

+ (instancetype)dataSourceWithTeam:(BSTeamMO *)team;
+ (instancetype)dataSourceWithEvent:(BSEventMO *)event;

@end
