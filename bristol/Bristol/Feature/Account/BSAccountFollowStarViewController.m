//
//  BSAccountFollowStarViewController.m
//  Bristol
//
//  Created by Bo on 3/23/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAccountFollowStarViewController.h"
#import "BSAccountFollowStarCollectionViewCell.h"
#import "BSUserMO.h"

@interface BSAccountFollowStarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation BSAccountFollowStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

+ (instancetype)instanceFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"BSAccountFollowStarViewController"];
}

- (IBAction)btnDoneTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLoginNotification object:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_followedUsers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSUserMO *followedStar = [_followedUsers objectAtIndex:indexPath.row];
    BSAccountFollowStarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSAccountFollowStarCollectionViewCell" forIndexPath:indexPath];
    [cell.avatarBtn configWithUser:followedStar];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(70.0f, 70.0f);
}

@end
