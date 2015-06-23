//
//  BSTopTenWeekCollectionCell.m
//  Bristol
//
//  Created by Bo on 3/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenWeekCollectionCell.h"
#import "BSTopOneCollectionViewCell.h"
#import "BSTopTenCollectionViewCell.h"
#import "BSHighestRankCollectionViewCell.h"
#import "BSNoHighlightCollectionViewCell.h"

#import "BSHighlightMO.h"
#import "BSUserMO.h"
#import "BSTopRankDataModel.h"

#import "BSCoreImageManager.h"

#import "UIControl+EventTrack.h"

#define DeviceMainScreenSize [[UIScreen mainScreen] bounds].size
#define kRankCellHeight 85.0f
#define kNohighlightCellHeight 135.0f
#define kShareCellHeight 200.0f

@implementation BSTopTenWeekCollectionCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	_toptenColletionView.scrollsToTop = NO;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.top = 0;
}

#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items;
    if (section == 0 || section == 2) {
        items = 1;
    } else {
        items = 9;
    }
    
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSHighlightMO *topHighlight = nil;
    switch (indexPath.section) {
        default:
        case 0: {
            if (self.highlightAry.count >= 1) {
                topHighlight = [self.highlightAry firstObject];
            }
			BSTopOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSTopOneCollectionViewCell" forIndexPath:indexPath];
			[cell.btnHighlight configWithHighlight:topHighlight completion:^(UIImage *image) {
				CGRect frame = cell.multiplyBlendHostView.frame;
				frame = CGRectMake(frame.origin.x / cell.width, frame.origin.y / cell.height, frame.size.width / cell.width, frame.size.height / cell.height);
				UIImage *imageBlend = [[BSCoreImageManager sharedManager] multiplyBlendImage:image frameNormalized:frame];
				[cell.btnHighlight setImage:imageBlend forState:UIControlStateNormal];
			}];
			cell.btnHighlight.eventTrackProperties = @{@"channel_rank":@(1)};
            [cell.avatarBtn configWithUser:topHighlight.user];
            NSString *userName = topHighlight.user.name_id;
            if (!userName) {
                userName = ZPLocalizedString(@"NAME");
            }
            [cell.userNameLbl setText:userName.uppercaseString];
            NSString *totalHighlightStr = [NSString stringWithFormat:ZPLocalizedString(@"Out of %i highlights"), _totalHighlightNum];
            [cell.highlightNumLbl setText:totalHighlightStr];
            return cell;
        }
        case 1: {
            BSTopTenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSTopTenCollectionViewCell" forIndexPath:indexPath];
            cell.topNumLbl.text = [NSString stringWithFormat:@"%i", (int)(indexPath.row+2)];

            if (self.highlightAry.count >= 2 && indexPath.row < (self.highlightAry.count - 1)) {
                topHighlight = [self.highlightAry objectAtIndex:(indexPath.row + 1)];
            }
            [cell.btnHighlight configWithHighlight:topHighlight];
			cell.btnHighlight.eventTrackProperties = @{@"channel_rank":@(indexPath.row+2)};
            return cell;
        }
        case 2: {
            if (_highlightRankAry.count == 0) {
                BSNoHighlightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSNoHighlightCollectionViewCell" forIndexPath:indexPath];
                return cell;
            } else {
                BSHighestRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSHighestRankCollectionViewCell" forIndexPath:indexPath];
                cell.highlightRankAry = _highlightRankAry;
                [cell.highlightRankCollectionView reloadData];
                return cell;
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float screenWidth = DeviceMainScreenSize.width;
    if (indexPath.section == 0) {
        return CGSizeMake(screenWidth, screenWidth - 1);
    } else if(indexPath.section == 1){
        CGFloat width = (collectionView.width - (kHighlightCellColumnCount - 1)) / kHighlightCellColumnCount;
        return CGSizeMake(width, width);
    } else {
        if (_highlightRankAry.count == 0) {
            return CGSizeMake(self.width, kNohighlightCellHeight);
        }else {
            NSInteger rankCellCount;
            if (_highlightRankAry.count >= 3) {
                rankCellCount = 3;
            } else {
                rankCellCount = _highlightRankAry.count;
            }
            
            return CGSizeMake(self.width, kRankCellHeight * (rankCellCount + 1) + kShareCellHeight);
        }
    }
}

@end
