//
//  BSLoadMoreTableViewCell.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSLoadMoreTableViewCell.h"

@interface BSLoadMoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

@property (weak, nonatomic) IBOutlet UIView *noMoreDataView;

@property (weak, nonatomic) IBOutlet UIView *faildView;


@end

@implementation BSLoadMoreTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.loadMoreType = BSLoadMoreTypeLoading;
}

- (void)_hideLoadingView:(BOOL)loadingView noMoreDataView:(BOOL)noMoreDataView faildView:(BOOL)faildView {
	_loadingView.hidden = loadingView;
	_noMoreDataView.hidden = noMoreDataView;
	_faildView.hidden = faildView;
	if (!loadingView) {
		[_loadingActivity startAnimating];
	} else {
		[_loadingActivity stopAnimating];
	}
}

- (void)setLoadMoreType:(BSLoadMoreType)loadMoreType {
	_loadMoreType = loadMoreType;
	switch (_loadMoreType) {
		case BSLoadMoreTypeLoading:
		{
			[self _hideLoadingView:NO noMoreDataView:YES faildView:YES];
			break;
		}

		case BSLoadMoreTypeNoMore:
		{
			[self _hideLoadingView:YES noMoreDataView:NO faildView:YES];
			break;
		}

		case BSLoadMoreTypeFaild:
		{
			[self _hideLoadingView:YES noMoreDataView:YES faildView:NO];
			break;
		}
	}
}

@end
