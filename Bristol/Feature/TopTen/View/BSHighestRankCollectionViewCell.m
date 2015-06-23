//
//  BSHighestRankCollectionViewCell.m
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighestRankCollectionViewCell.h"
#import "BSRankTitleCollectionViewCell.h"
#import "BSRankCollectionViewCell.h"
#import "BSShareRankHighlightCollectionViewCell.h"
#import "BSTopRankDataModel.h"
#import "BSFeedViewController.h"

#define kRankCellHeight 85.0f
#define kShareCellHeight 200.0f

@implementation BSHighestRankCollectionViewCell

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else {
        if (_highlightRankAry.count >= 3) {
            return 3;
        } else {
            return [_highlightRankAry count];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        default:
        case 0:{
            BSRankTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSRankTitleCollectionViewCell" forIndexPath:indexPath];
            return cell;
        }
        case 1:{
            BSRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSRankCollectionViewCell" forIndexPath:indexPath];
            BSTopRankDataModel *rankDataModel = [_highlightRankAry objectAtIndex:indexPath.row];
            long long rank = rankDataModel.rank;
            NSString *rankStr = [NSString stringWithFormat:@"%lld", rank];
            BSHighlightMO *highlight = rankDataModel.highlight;
//            [cell.highlightLbl setText:highlight.name];
            [cell.rankLbl setText:rankStr];
            [cell.likedLbl setText:highlight.likes_count.stringValue];
            [cell.viewedLbl setText:highlight.played_times.stringValue];
            [cell.highlightBtn configWithHighlight:highlight];
            
            return cell;
        }
        case 2:{
            BSShareRankHighlightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSShareRankHighlightCollectionViewCell" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return CGSizeMake(self.width, kRankCellHeight);
    } else {
        return CGSizeMake(self.width, kShareCellHeight);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BSTopRankDataModel *rankDataModel = [_highlightRankAry objectAtIndex:indexPath.row];
        BSHighlightMO *highlight = rankDataModel.highlight;
        UIViewController *pushingViewController = [BSUtility getTopmostViewController];
        if (pushingViewController && highlight) {
            BSFeedViewController *vc = [BSFeedViewController instanceWithHighlight:highlight];
            if (pushingViewController.navigationController) {
                [pushingViewController.navigationController pushViewController:vc animated:YES];
            }
            else {
                [pushingViewController presentViewController:vc animated:YES completion:NULL];
            }
        }

    }
}
@end
