//
//  BSFeedRecommendTableViewCell.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "BSDataModels.h"

@class BSFeedRecommendTableViewCell;
@protocol BSRecommendTableViewCellDelegate <NSObject>
@optional
- (void)feedRecommendCell:(BSFeedRecommendTableViewCell *)cell didTapCloseButton:(UIButton *)button;

@end

@interface BSFeedRecommendTableViewCell : BSBaseTableViewCell

@property (weak, nonatomic) id <BSRecommendTableViewCellDelegate> delegate;
@property (weak, nonatomic, readonly) id bindingData;

- (void)configWithTeam:(BSTeamMO *)team;
- (void)configWithEvent:(BSEventMO *)event;
- (void)configWithDataModel:(id)dataModel;

@end
