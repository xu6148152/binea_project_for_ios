//
//  BSExploreCollectionViewCell.m
//  Bristol
//
//  Created by Yangfan Huang on 3/31/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreCollectionViewCell.h"
#import "FXBlurView.h"

#import "BSExploreHighlightCollectionViewDataSource.h"
#import "BSExploreTeamTableViewDataSource.h"
#import "BSExploreEventTableViewDataSource.h"
#import "BSExploreSearchPeopleTableViewDataSource.h"
#import "BSExploreSearchTeamTableViewDataSource.h"
#import "BSExploreSearchEventTableViewDataSource.h"

#import "UITableView+GlobalUI.h"


@interface BSExploreCollectionViewCell()
@property (weak, nonatomic) IBOutlet UICollectionView *highlightCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *highlightOrPeopleButton;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;

@property (weak, nonatomic) IBOutlet UIView *blendingView;
@property (weak, nonatomic) IBOutlet FXBlurView *multiplyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blendingLeftConstraint;

@property (nonatomic) BOOL isSearch;
@property (nonatomic) BSExploreTab selectedTab;

@property (nonatomic) BSExploreHighlightCollectionViewDataSource *highlightDataSource;
@property (nonatomic) BSExploreTeamTableViewDataSource *teamDataSource;
@property (nonatomic) BSExploreEventTableViewDataSource *eventDataSource;

@property (nonatomic) BSExploreSearchPeopleTableViewDataSource *searchPeopleDataSource;
@property (nonatomic) BSExploreSearchTeamTableViewDataSource *searchTeamDataSource;
@property (nonatomic) BSExploreSearchEventTableViewDataSource *searchEventDataSource;


@end

@implementation BSExploreCollectionViewCell

- (void) configureCellWithTabBarHeight:(CGFloat)tabBarHeight isSearch:(BOOL)isSearch {
	self.isSearch = isSearch;
	
	if (tabBarHeight > 0) {
		[self.highlightCollectionView setContentInset:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
		[self.highlightCollectionView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
		[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
		[self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, tabBarHeight, 0)];
	}
	
	if (!self.isSearch) {
		[self checkDataSource];
	} else {
		[self.highlightOrPeopleButton setImage:[UIImage imageNamed:@"explore_member"] forState:UIControlStateNormal];
	}
	
	[self.tableView setGlobalUI];
}

- (void) willAppear {
	_multiplyView.dynamic = YES;
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void) willDisappear {
	_multiplyView.dynamic = NO;

}

- (BOOL) selectTab:(BSExploreTab) tab animated:(BOOL)animated{
	if (self.selectedTab == tab) {
		return NO;
	}
	
	if (self.selectTabDelegate) {
		[self.selectTabDelegate didSelectTab:tab];
	}
	
	self.selectedTab = tab;
	CGFloat tabWidth = (self.width - 90) / 3;
	CGFloat left = 45;
	
	switch (tab) {
		case BSExploreTabEvent:
			left += tabWidth;
		case BSExploreTabTeam:
			left += tabWidth;
		case BSExploreTabHighlightOrPeople:
			break;
		default:
			return NO;
	}
	
	[self checkDataSource];

	[UIView animateWithDuration:animated ? kDefaultAnimateDuration : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
		self.blendingLeftConstraint.constant = left;
		[self.blendingView layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
	
	return YES;
}

- (void) checkDataSource {
	if (!self.isSearch && self.selectedTab == BSExploreTabHighlightOrPeople) {
		self.highlightCollectionView.hidden = NO;
		self.highlightCollectionView.scrollsToTop = YES;
		self.tableView.hidden = YES;
		self.tableView.scrollsToTop = NO;
	} else {
		self.highlightCollectionView.hidden = YES;
		self.highlightCollectionView.scrollsToTop = NO;
		self.tableView.hidden = NO;
		self.tableView.scrollsToTop = YES;
	}
	
	BOOL needRefresh = YES;
	BSBaseTableViewDataSource *dataSource;
	switch (self.selectedTab) {
		case BSExploreTabHighlightOrPeople:
			if (self.isSearch) {
				if (!self.searchPeopleDataSource) {
					self.searchPeopleDataSource = [[BSExploreSearchPeopleTableViewDataSource alloc] init];
					self.searchPeopleDataSource.scrollDelegate = self.scrollDelegate;
				}
				self.searchPeopleDataSource.keyword = self.keyword;
				dataSource = self.searchPeopleDataSource;
			} else {
				if (!self.highlightDataSource) {
					self.highlightDataSource = [[BSExploreHighlightCollectionViewDataSource alloc] init];
					self.highlightCollectionView.dataSource = self.highlightDataSource;
					self.highlightCollectionView.delegate = self.highlightDataSource;
				} else {
					[self.highlightDataSource refreshDataWithSuccess:NULL faild:NULL];
				}
				[self.highlightCollectionView reloadData];
				return;
			}
			break;
		case BSExploreTabTeam:
			if (self.isSearch) {
				if (!self.searchTeamDataSource) {
					self.searchTeamDataSource = [[BSExploreSearchTeamTableViewDataSource alloc] init];
					self.searchTeamDataSource.scrollDelegate = self.scrollDelegate;
				}
				self.searchTeamDataSource.keyword = self.keyword;
				dataSource = self.searchTeamDataSource;
			} else {
				if (!self.teamDataSource) {
					self.teamDataSource = [[BSExploreTeamTableViewDataSource alloc] init];
					needRefresh = NO;
				}
				dataSource = self.teamDataSource;
			}
			break;
		case BSExploreTabEvent:
			if (self.isSearch) {
				if (!self.searchEventDataSource) {
					self.searchEventDataSource = [[BSExploreSearchEventTableViewDataSource alloc] init];
					self.searchEventDataSource.scrollDelegate = self.scrollDelegate;
				}
				self.searchEventDataSource.keyword = self.keyword;
				
				dataSource = self.searchEventDataSource;
			} else {
				if (!self.eventDataSource) {
					self.eventDataSource = [[BSExploreEventTableViewDataSource alloc] init];
					needRefresh = NO;
				}
				dataSource = self.eventDataSource;
			}
			break;
		default:
			return;
	}
	
	if (needRefresh || self.isSearch) {
		[dataSource refreshDataWithSuccess:NULL faild:NULL];
	}
	self.tableView.dataSource = dataSource;
	if ([dataSource conformsToProtocol:@protocol(UITableViewDelegate)]) {
		self.tableView.delegate = (id<UITableViewDelegate>)dataSource;
	}
	[self.tableView reloadData];
}

- (void) setKeyword:(NSString *)keyword {
	if (self.isSearch) {
		_keyword = keyword;
		[self checkDataSource];
	}
}

#pragma mark - UI events
- (IBAction)onHighlightOrPeopleButtonTapped:(id)sender {
	[self selectTab:BSExploreTabHighlightOrPeople animated:YES];
}

- (IBAction)onTeamButtonTapped:(id)sender {
	[self selectTab:BSExploreTabTeam animated:YES];
}

- (IBAction)onEventButtonTapped:(id)sender {
	[self selectTab:BSExploreTabEvent animated:YES];
}

@end
