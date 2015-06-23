//
//  BSExploreViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/5/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSExploreViewController.h"
#import "BSExploreCollectionViewCell.h"

#import "BSExploreHighlightCollectionViewDataSource.h"
#import "BSExploreTeamTableViewDataSource.h"
#import "BSExploreEventTableViewDataSource.h"
#import "BSExploreSearchPeopleTableViewDataSource.h"
#import "BSExploreSearchTeamTableViewDataSource.h"
#import "BSExploreSearchEventTableViewDataSource.h"
#import "BSBaseTableViewCell.h"


@interface BSExploreViewController ()<UITextFieldDelegate, BSBaseTableViewScrollDelegate, BSExploreCollectionViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UICollectionView *horizontalCollectionView;
@property (nonatomic) BOOL inSearch;
@property (nonatomic) BSExploreTab selectedTab;
@property (nonatomic) BSExploreCollectionViewCell *exploreCell;
@property (nonatomic) BSExploreCollectionViewCell *searchCell;
@end

@implementation BSExploreViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Explore" bundle:nil] instantiateViewControllerWithIdentifier:@"BSExploreViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self updatePlaceholder];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.inSearch) {
		if (self.searchCell) {
			[self.searchCell willAppear];
		}
	} else if (self.exploreCell) {
		[self.exploreCell willAppear];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.exploreCell willDisappear];
	[self.searchCell willDisappear];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) enterSearching {
	self.inSearch = YES;
	[self.searchButton setTitle:ZPLocalizedString(@"Cancel") forState:UIControlStateNormal];
	[self.searchButton setImage:nil forState:UIControlStateNormal];
	
	self.horizontalCollectionView.scrollEnabled = YES;
	[self.horizontalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	self.horizontalCollectionView.scrollEnabled = NO;
	
	[self.exploreCell willDisappear];
	
	if (!self.searchCell) {
		[self collectionView:self.horizontalCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	}
	
	if (![self.searchCell selectTab:self.selectedTab animated:NO]) {
		[BSEventTracker trackPageView:self];
	} // else tracked in didSelectTab:
	[self.searchCell willAppear];
	
	[self updatePlaceholder];
}

- (void) leaveSearching {
	self.searchTextField.text = @"";
	self.inSearch = NO;

	[self.searchButton setTitle:nil forState:UIControlStateNormal];
	[self.searchButton setImage:[UIImage imageNamed:@"explore_search"] forState:UIControlStateNormal];
	[self.searchTextField endEditing:YES];
	
	self.horizontalCollectionView.scrollEnabled = YES;
	[self.horizontalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
	self.horizontalCollectionView.scrollEnabled = NO;
	
	if (![self.exploreCell selectTab:self.selectedTab animated:NO]) {
		[BSEventTracker trackPageView:self];
	} // else tracked in didSelectTab:
	[self.exploreCell willAppear];
	self.searchCell.keyword = nil;
	[self.searchCell willDisappear];
	
	[self updatePlaceholder];
}

- (void) updatePlaceholder {
	if (!self.inSearch) {
		self.searchTextField.placeholder = ZPLocalizedString(@"Search");
	} else {
		switch (self.selectedTab) {
			case BSExploreTabHighlightOrPeople:
				self.searchTextField.placeholder = ZPLocalizedString(@"Search people");
				break;
			case BSExploreTabTeam:
				self.searchTextField.placeholder = ZPLocalizedString(@"Search teams");
				break;
			case BSExploreTabEvent:
				self.searchTextField.placeholder = ZPLocalizedString(@"Search events");
				break;
			default:
				break;
		}
	}
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[BSEventTracker trackTap:@"search" page:self properties:nil];
	[self enterSearching];
}

-(void) handleTextChange:(NSNotification *)notification {
	if (!self.inSearch) {
		return;
	}
	
	self.searchCell.keyword = self.searchTextField.text;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	self.searchCell.keyword = nil;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.searchTextField resignFirstResponder];
	return YES;
}

- (IBAction)onSearchButtonTapped:(id)sender {
	if (self.inSearch) {
		[self leaveSearching];
	} else {
		[self.searchTextField becomeFirstResponder];
	}
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && self.exploreCell) {
		return self.exploreCell;
	}
	
	if (indexPath.row == 1 && self.searchCell) {
		return self.searchCell;
	}
	
	BSExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSExploreCollectionViewCell" forIndexPath:indexPath];
	[cell configureCellWithTabBarHeight:[self hidesBottomBarWhenPushed] ? 0 : self.tabBarController.tabBar.height isSearch:indexPath.row == 1];
	cell.scrollDelegate = self;
	cell.selectTabDelegate = self;
	
	if (indexPath.row == 0) {
		self.exploreCell = cell;
	} else {
		self.searchCell = cell;
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(collectionView.width, collectionView.height);
}

#pragma mark - BSBaseTableViewScrollDelegate
- (void)tableViewDidScroll:(UITableView *)tableView {
	[self.searchTextField resignFirstResponder];
}

#pragma mark - BSExploreCollectionViewCellDelegate
- (void) didSelectTab:(BSExploreTab)tab {
	self.selectedTab = tab;
	
	[self updatePlaceholder];
	[BSEventTracker trackPageView:self];
}

#pragma mark - event tracking
- (NSString *) pageName {
	switch (self.selectedTab) {
		case BSExploreTabTeam:
			return self.inSearch ? @"explore_search_teams" : @"explore_teams";
		case BSExploreTabEvent:
			return self.inSearch ? @"explore_search_events" : @"explore_events";
		case BSExploreTabHighlightOrPeople:
		default:
			return self.inSearch ? @"explore_search_people" : @"explore_videos";
	}
}
@end
