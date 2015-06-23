//
//  BSUserTableViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewDataSource.h"

@interface BSUserTableViewDataSource : BSBaseTableViewDataSource
{
	NSArray *_users;
}

@property (nonatomic) NSDictionary *eventTrackProperties;
@end
