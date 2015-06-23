//
//  BSFollowPeopleTableViewCell.m
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFollowPeopleTableViewCell.h"
#import "BSFollowPeopleCollectionViewCell.h"

@implementation BSFollowPeopleTableViewCell

- (void)awakeFromNib {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_userHighlightAry count] > 0 ? 3 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSFollowPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSFollowPeopleCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < _userHighlightAry.count) {
        [cell.btnHighlight configWithHighlight:[_userHighlightAry objectAtIndex:indexPath.row]];
    } else {
        [cell.btnHighlight configWithHighlight:nil];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_userHighlightAry.count > 0) {
        float length = (self.width - (kHighlightCellColumnCount - 1)) / kHighlightCellColumnCount;
        return CGSizeMake(length, length);
    } else {
        return CGSizeZero;
    }
}

@end
