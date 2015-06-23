//
//  BSRankCollectionViewCell.h
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHighlightButton.h"

@interface BSRankCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *highlightLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet BSHighlightButton *highlightBtn;
@property (weak, nonatomic) IBOutlet UILabel *likedLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewedLbl;

@end
