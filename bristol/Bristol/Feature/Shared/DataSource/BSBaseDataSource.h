//
//  BSBaseDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/16/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBaseDataSource : NSObject

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild;

@end
