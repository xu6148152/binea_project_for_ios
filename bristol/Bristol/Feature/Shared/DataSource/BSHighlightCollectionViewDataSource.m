//
//  BSHighlightCollectionViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightCollectionViewDataSource.h"
#import "BSProfileHighlightCollectionViewCell.h"
#import "BSFeedViewController.h"

#import "UIControl+EventTrack.h"

@implementation BSHighlightCollectionViewDataSource

- (id)init {
	self = [super init];
	if (self) {
		_highlights = [NSMutableArray array];
	}
	return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	_collectionView = collectionView;
	_collectionView.delegate = self;
	return _highlights ? _highlights.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	BSProfileHighlightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BSProfileHighlightCollectionViewCell.className forIndexPath:indexPath];
	[cell.btnHighlight configWithHighlight:_highlights[indexPath.row]];
	cell.btnHighlight.eventTrackProperties = @{@"list_rank":@(indexPath.row+1)};
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[BSUtility pushViewController:[BSFeedViewController instanceWithHighlight:_highlights[indexPath.row]]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = (collectionView.width - (kHighlightCellColumnCount - 1)) / kHighlightCellColumnCount;
	return CGSizeMake(width, width);
}
@end
