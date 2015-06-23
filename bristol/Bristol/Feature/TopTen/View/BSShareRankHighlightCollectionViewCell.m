//
//  BSShareRankHighlightCollectionViewCell.m
//  Bristol
//
//  Created by Bo on 4/1/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSShareRankHighlightCollectionViewCell.h"

@implementation BSShareRankHighlightCollectionViewCell

- (UIViewController *)_getTop10ViewController {
    UITabBarController *vc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (vc.viewControllers.count > 1) {
        UINavigationController *nav = vc.viewControllers[1];
        return nav.rootViewController;
    } else {
        return nil;
    }
}

- (IBAction)shareBtnTapped:(id)sender {
    UIViewController<BSShareRankHighlightCollectionViewCellDelegate> *vc = (UIViewController<BSShareRankHighlightCollectionViewCellDelegate> *)[self _getTop10ViewController];
    if ([vc respondsToSelector:@selector(shareRankHighlightCollectionViewCell:didTapShareButton:)]) {
        [vc shareRankHighlightCollectionViewCell:self didTapShareButton:sender];
    }
}

@end
