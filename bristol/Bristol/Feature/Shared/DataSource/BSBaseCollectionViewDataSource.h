//
//  BSBaseCollectionViewDataSource.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseDataSource.h"

@interface BSBaseCollectionViewDataSource : BSBaseDataSource <UICollectionViewDataSource>
{
@protected
	__weak UICollectionView *_collectionView;
}

@end
