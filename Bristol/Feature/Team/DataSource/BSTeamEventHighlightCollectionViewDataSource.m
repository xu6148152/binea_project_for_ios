//
//  BSTeamEventHighlightCollectionViewDataSource.m
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamEventHighlightCollectionViewDataSource.h"
#import "BSTeamAllHighlightsHttpRequest.h"
#import "BSHighlightsDataModel.h"
#import "BSEventAllHighlightsHttpRequest.h"

@implementation BSTeamEventHighlightCollectionViewDataSource
{
	BSTeamMO *_team;
	BSEventMO *_event;
	BSTeamAllHighlightsHttpRequest *_requestRefreshTeam;
	BSEventAllHighlightsHttpRequest *_requestRefreshEvent;
	BOOL _isTeamData;
}

+ (instancetype)dataSourceWithTeam:(BSTeamMO *)team {
	return [[[self class] alloc] initWithTeam:team];
}

+ (instancetype)dataSourceWithEvent:(BSEventMO *)event {
	return [[[self class] alloc] initWithEvent:event];
}

- (id)initWithTeam:(BSTeamMO *)team {
	NSParameterAssert([team isKindOfClass:[BSTeamMO class]]);
	if (self = [super init]) {
		_team = team;
		_isTeamData = YES;
	}

	return self;
}

- (id)initWithEvent:(BSEventMO *)event {
	NSParameterAssert([event isKindOfClass:[BSEventMO class]]);
	if (self = [super init]) {
		_event = event;
		_isTeamData = NO;
	}

	return self;
}

- (void)refreshDataWithSuccess:(ZPVoidBlock)success faild:(ZPErrorBlock)faild {
	if (_isTeamData) {
		_requestRefreshTeam = [BSTeamAllHighlightsHttpRequest request];
		_requestRefreshTeam.teamId = _team.identifierValue;
		_requestRefreshTeam.startIndex = 0;
		NSUInteger countInOnePage = _requestRefreshTeam.countInOnePage;
		[_requestRefreshTeam postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			_highlights = [((BSHighlightsDataModel *)result.dataModel).highlights mutableCopy];
			_isNoMoreData = _highlights.count < countInOnePage;

		    [_collectionView reloadData];
		    ZPInvokeBlock(success);
			_requestRefreshTeam = nil;
		} failedBlock: ^(BSHttpResponseDataModel *result) {
			ZPInvokeBlock(faild, result.error);
			_requestRefreshTeam = nil;
		}];
	}
	else {
		_requestRefreshEvent = [BSEventAllHighlightsHttpRequest request];
		_requestRefreshEvent.eventId = _event.identifierValue;
		_requestRefreshEvent.startIndex = 0;
		NSUInteger countInOnePage = _requestRefreshEvent.countInOnePage;
		[_requestRefreshEvent postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
			_highlights = [((BSHighlightsDataModel *)result.dataModel).highlights mutableCopy];
			_isNoMoreData = _highlights.count < countInOnePage;

		    [_collectionView reloadData];
			ZPInvokeBlock(success);
			_requestRefreshEvent = nil;
		} failedBlock: ^(BSHttpResponseDataModel *result) {
			ZPInvokeBlock(faild, result.error);
			_requestRefreshEvent = nil;
		}];
	}
}

- (BSCustomHttpRequest *)getNewLoadMoreDataHttpRequest {
	if (_isTeamData) {
		if (_requestRefreshTeam) {
			return nil;
		}
		BSTeamAllHighlightsHttpRequest *request = [BSTeamAllHighlightsHttpRequest request];
		request.teamId = _team.identifierValue;
		request.startIndex = _highlights.count;
		return request;
	}
	else {
		if (_requestRefreshEvent) {
			return nil;
		}
		BSEventAllHighlightsHttpRequest *request = [BSEventAllHighlightsHttpRequest request];
		request.eventId = _event.identifierValue;
		request.startIndex = _highlights.count;
		return request;
	}
}

@end
