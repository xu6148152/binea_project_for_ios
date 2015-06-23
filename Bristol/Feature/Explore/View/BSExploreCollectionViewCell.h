//
//  BSExploreCollectionViewCell.h
//  Bristol
//
//  Created by Yangfan Huang on 3/31/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseCollectionViewCell.h"
#import "BSBaseTableViewDataSource.h"

typedef NS_ENUM (NSUInteger, BSExploreTab) {
	BSExploreTabHighlightOrPeople,
	BSExploreTabTeam,
	BSExploreTabEvent,
};

@protocol BSExploreCollectionViewCellDelegate <NSObject>

- (void) didSelectTab:(BSExploreTab)tab;

@end

@interface BSExploreCollectionViewCell : BSBaseCollectionViewCell

@property (nonatomic, weak) id<BSBaseTableViewScrollDelegate> scrollDelegate;
@property (nonatomic, weak) id<BSExploreCollectionViewCellDelegate> selectTabDelegate;
@property (nonatomic) NSString *keyword;

- (void) configureCellWithTabBarHeight:(CGFloat)tabBarHeight isSearch:(BOOL)isSearch;
- (void) willAppear;
- (void) willDisappear;
- (BOOL) selectTab:(BSExploreTab) tab animated:(BOOL)animated;

@end
