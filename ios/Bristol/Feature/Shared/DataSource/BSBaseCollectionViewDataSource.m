//
//  BSBaseCollectionViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 3/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseCollectionViewDataSource.h"

@implementation BSBaseCollectionViewDataSource

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
