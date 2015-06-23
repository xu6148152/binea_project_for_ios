//
//  BSHighlightLoadingMoreCollectionViewDataSource.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightLoadingMoreCollectionViewDataSource.h"
#import "BSLoadMoreCollectionViewCell.h"
#import "BSHighlightsDataModel.h"

#import "BSEventTracker.h"

@implementation BSHighlightLoadingMoreCollectionViewDataSource
{
	BSLoadMoreCollectionViewCell *_loadMoreCollectionViewCell;
	BSCustomHttpRequest *_loadMoreHttpRequest;
}

- (BSCustomHttpRequest *)getNewLoadMoreDataHttpRequest {
	NSAssert(NO, OverwriteRequiredMessage);
	return nil;
}

- (void)_loadMoreFeeds {
	if (!_loadMoreHttpRequest) {
		_loadMoreHttpRequest = [self getNewLoadMoreDataHttpRequest];
		if (_loadMoreHttpRequest) {
			[BSEventTracker trackAction:@"load_more_videos" page:nil properties:nil];
			
			_loadMoreCollectionViewCell.hidden = NO;
			_loadMoreCollectionViewCell.loadMoreType = BSLoadMoreTypeLoading;
			
			[_loadMoreHttpRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
				NSArray *highlightsPage = ((BSHighlightsDataModel *)result.dataModel).highlights;
				_isNoMoreData = highlightsPage.count == 0;
				
				if (_isNoMoreData) {
					_loadMoreCollectionViewCell.loadMoreType = BSLoadMoreTypeNoMore;
				} else {
					[_highlights addObjectsFromArray:highlightsPage];
					[_collectionView reloadData];
				}
				
				_loadMoreHttpRequest = nil;
			} failedBlock:^(BSHttpResponseDataModel *result) {
				_loadMoreCollectionViewCell.loadMoreType = BSLoadMoreTypeFaild;
				_loadMoreCollectionViewCell.lblFaild.text = result.error.localizedDescription;
				
				_loadMoreHttpRequest = nil;
			}];
		} else {
			_loadMoreCollectionViewCell.hidden = YES;
		}
	}
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	_collectionView = collectionView;
	_collectionView.delegate = self;
	return _highlights.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < _highlights.count) {
		return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	} else {
		_loadMoreCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:BSLoadMoreCollectionViewCell.className forIndexPath:indexPath];
		[_loadMoreCollectionViewCell.btnRetry addTarget:self action:@selector(_loadMoreFeeds) forControlEvents:UIControlEventTouchUpInside];
		return _loadMoreCollectionViewCell;
	}
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < _highlights.count) {
		[super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
	} else {
		
	}
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < _highlights.count) {
		
	} else {
		if (!_isNoMoreData) {
			[self _loadMoreFeeds];
		} else {
			_loadMoreCollectionViewCell.hidden = YES;
		}
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < _highlights.count) {
		return [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
	} else {
		if (_highlights.count >= kHighlightCellColumnCount) {
			return CGSizeMake(collectionView.width, BSLoadMoreCellHeight);
		} else {
			return CGSizeZero;
		}
	}
}

@end
