//
//  BSTopTenWeekCollectionCell.h
//  Bristol
//
//  Created by Bo on 3/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHighlightMO.h"

@interface BSTopTenWeekCollectionCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nohighlightLbl;
@property (nonatomic, strong) NSArray *highlightAry;
@property (nonatomic, strong) NSArray *highlightRankAry;
@property (nonatomic, assign) DataModelIdType totalHighlightNum;
@property (weak, nonatomic) IBOutlet UICollectionView *toptenColletionView;

@end
