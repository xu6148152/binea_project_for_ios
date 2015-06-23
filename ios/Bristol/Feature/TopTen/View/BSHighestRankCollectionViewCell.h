//
//  BSHighestRankCollectionViewCell.h
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSHighestRankCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *highlightRankAry;
@property (weak, nonatomic) IBOutlet UICollectionView *highlightRankCollectionView;

@end
