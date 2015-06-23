//
//  BSTopTenCollectionViewCell.h
//  Bristol
//
//  Created by Bo on 1/29/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHighlightButton.h"

@interface BSTopTenCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BSHighlightButton *btnHighlight;

@property (weak, nonatomic) IBOutlet UILabel *topNumLbl;

@end
