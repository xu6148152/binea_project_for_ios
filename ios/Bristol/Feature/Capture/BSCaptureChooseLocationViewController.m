//
//  BSCaptureChooseLocationViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCaptureChooseLocationViewController.h"
#import "BSAuthorizationViewController.h"

#import "BSQueryNearbyPlacesHttpRequest.h"
#import "BSHighlightPlaceDataModel.h"

#import "INTULocationManager.h"

@interface BSCaptureChooseLocationViewController ()
{
    CLLocation *_currentLocation;
    NSMutableArray *_aryPlacesSearched;
	NSString *_searchString;
	id _selectedObject;
}
@end

#define kSearchContent @"kSearchContent"

@implementation BSCaptureChooseLocationViewController
@synthesize selectedObject = _selectedObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZPLocalizedString(@"Choose a Location");
	
	[self.searchDisplayController.searchResultsTableView setGlobalUI];
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:BSBasePickerTableViewCell.className bundle:nil] forCellReuseIdentifier:BSBasePickerTableViewCell.className];
    
    if (!_placesDataModel) {
        [self _requestLocation];
    } else {
        [self reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSIndexPath *indexPath = [self _indexPathForSelectedObject:self.selectedObject];
	[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
		BSAuthorizationViewController *vc = [BSAuthorizationViewController instanceFromDefaultNibWithType:BSAuthorizationTypeLocation];
		[vc showInViewController:self dismissCompletion:nil];
	}
}

- (void)setSelectedObject:(id)selectedObject {
	BSBasePickerTableViewCell *cellOld = (BSBasePickerTableViewCell *)[self.tableView cellForRowAtIndexPath:[self _indexPathForSelectedObject:self.selectedObject]];
	[cellOld setIsHighlight:NO];
	
	_selectedObject = selectedObject;
	ZPInvokeBlock(self.selectedObjectDidChangedBlock, selectedObject);
	
	[self _selectSelectedCell];
}

- (NSIndexPath *)_indexPathForSelectedObject:(id)selectedObject {
	NSInteger section = 0, row = 0;
	if ([selectedObject isKindOfClass:[BSEventMO class]]) {
		row = [_placesDataModel.events indexOfObject:selectedObject];
		section = 1;
	} else if ([selectedObject isKindOfClass:[BSHighlightPlaceDataModel class]]) {
		row = [_placesDataModel.places indexOfObject:selectedObject] + _placesDataModel.events.count;
		section = 1;
	} else if ([selectedObject isKindOfClass:[NSString class]]) {
		row = [[BSDataManager sharedInstance].recentCreatedLocations indexOfObject:selectedObject];
		section = 2;
	}
	return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)_selectSelectedCell {
	NSIndexPath *indexPath = [self _indexPathForSelectedObject:self.selectedObject];
	BSBasePickerTableViewCell *cellNew = (BSBasePickerTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[cellNew setIsHighlight:YES];
}

- (void)_requestLocation {
	ZPInvokeBlock(self.didStartRequest);
	
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        switch (status) {
            case INTULocationStatusSuccess:
            {
                _currentLocation = currentLocation;
                [self _requestNearby];
                break;
            }
            case INTULocationStatusTimedOut:
            {
                [BSUIGlobal showAlertMessage:ZPLocalizedString(@"Location request time out") cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
                    [self _requestLocation];
                }];
                break;
            }
            case INTULocationStatusServicesDenied:
            {
                [BSUIGlobal showAlertMessage:ZPLocalizedString(@"Location service is denied") cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Setting") actionHandler:^{
                    [BSUtility openSettingsApp];
                }];
                break;
            }
            case INTULocationStatusServicesDisabled:
            {
                [BSUIGlobal showAlertMessage:ZPLocalizedString(@"Location service is disabled") cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Setting") actionHandler:^{
                    [BSUtility openSettingsApp];
                }];
                break;
            }
            case INTULocationStatusServicesRestricted:
            {
                [BSUIGlobal showAlertMessage:ZPLocalizedString(@"Location service is restricted") cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Setting") actionHandler:^{
                    [BSUtility openSettingsApp];
                }];
                break;
            }
            default:
            {
                [BSUIGlobal showAlertMessage:ZPLocalizedString(@"Location request error") cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
                    [self _requestLocation];
                }];
                break;
            }
        }
    }];
}

- (void)_requestNearby {
    if (_currentLocation) {
        BSQueryNearbyPlacesHttpRequest *request = [BSQueryNearbyPlacesHttpRequest requestWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			_placesDataModel = result.dataModel;
			[self reloadData];
			
			ZPInvokeBlock(self.didSuccessRequest);
        } failedBlock:^(BSHttpResponseDataModel *result) {
            [BSUIGlobal showAlertMessage:result.error.localizedDescription cancelTitle:ZPLocalizedString(@"Cancel") cancelHandler:_didFaildRequest actionTitle:ZPLocalizedString(@"Try again") actionHandler:^{
                [self _requestNearby];
            }];
        }];
    }
}

#pragma mark - over write
- (NSArray *)getObjectsToBind {
    return nil;
}

- (void)reloadData {
	[self.tableView reloadData];
	
	[self _selectSelectedCell];
}

- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(id)object {
    if ([object isKindOfClass:[BSHighlightPlaceDataModel class]]) {
        BSHighlightPlaceDataModel *place = object;
        cell.lblTitle.text = place.nameLocalized;
        cell.imgViewIcon.image = [UIImage imageNamed:@"common_list_location_icon"];
        cell.showIcon = YES;
    } else if ([object isKindOfClass:[BSEventMO class]]) {
		BSEventMO *event = object;
		cell.lblTitle.text = event.name;
		cell.imgViewIcon.image = [UIImage imageNamed:@"common_list_event_icon"];
		cell.showIcon = YES;
	} else if ([object isKindOfClass:[NSString class]]) {
		cell.lblTitle.text = object;
		cell.imgViewIcon.image = [UIImage imageNamed:@"common_list_location_icon"];
		cell.showIcon = YES;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		cell.lblTitle.text = [NSString stringWithFormat:ZPLocalizedString(@"Create location format"), object[kSearchContent]];
		cell.imgViewIcon.image = [UIImage imageNamed:@"common_list_location_icon"];
		cell.showIcon = YES;
	} else {
		cell.lblTitle.text = ZPLocalizedString(@"No Location");
		cell.showIcon = NO;
	}
}

- (id)_getObjectForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	id object;
	if (tableView == self.tableView) {
		switch (indexPath.section) {
			case 0:
			default:
				object = nil;
				break;
			case 1:
				if (indexPath.row < _placesDataModel.events.count) {
					object = _placesDataModel.events[indexPath.row];
				} else {
					object = _placesDataModel.places[indexPath.row - _placesDataModel.events.count];
				}
				break;
			case 2:
				if (indexPath.row < [BSDataManager sharedInstance].recentCreatedLocations.count) {
					object = [BSDataManager sharedInstance].recentCreatedLocations[indexPath.row];
				}
				break;
		}
	} else {
		if (indexPath.row < _aryPlacesSearched.count) {
			object = _aryPlacesSearched[indexPath.row];
		} else {
			object = @{kSearchContent : _searchString};
		}
	}
	return object;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.tableView) {
		return 3;
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
		switch (section) {
			case 0:
			default:
				return 1;
			case 1:
				return _placesDataModel.events.count + _placesDataModel.places.count;
			case 2:
				return [BSDataManager sharedInstance].recentCreatedLocations.count;
		}
	} else {
		NSInteger additionalCount = _searchString.length > 0 ? 1 : 0;
		return _aryPlacesSearched.count + additionalCount;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		switch (section) {
			case 1:
			case 2:
			{
				NSInteger rows = [self tableView:tableView numberOfRowsInSection:section];
				return rows > 0 ? 22 : 0;
			}
		}
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	if (tableView == self.tableView) {
		switch (section) {
			case 1:
				title = ZPLocalizedString(@"Near me");
				break;
			case 2:
				title = ZPLocalizedString(@"Recent created locations");
				break;
		}
	}
	
	return [BSUIGlobal createCommonTableViewSectionHeaderWithTitle:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSBasePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSBasePickerTableViewCell.className forIndexPath:indexPath];
	[self configCell:cell withObject:[self _getObjectForTableView:tableView atIndexPath:indexPath]];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.tableView && indexPath.section == 2) {
		return YES;
	} else
		return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.tableView && indexPath.section == 2) {
		NSString *name = [BSDataManager sharedInstance].recentCreatedLocations[indexPath.row];
		[[BSDataManager sharedInstance] removeLocationWithName:name];
		
		[tableView beginUpdates];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView endUpdates];
	}
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id object;
    if (tableView == self.tableView) {
		object = [self _getObjectForTableView:tableView atIndexPath:indexPath];
    } else {
		[self.searchDisplayController setActive:NO animated:YES];
		
		if (indexPath.row >= _aryPlacesSearched.count) {
			[[BSDataManager sharedInstance] addLocationWithName:_searchString];
			object = _searchString;
			
			[self.tableView reloadData];
		} else {
			object = [self _getObjectForTableView:tableView atIndexPath:indexPath];
		}
	}
	self.selectedObject = object;
	
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[_aryPlacesSearched removeAllObjects];
	_searchString = searchString;
	if (searchString.length > 0) {
		if (!_aryPlacesSearched) {
			_aryPlacesSearched = [NSMutableArray array];
		}
		
		for (BSEventMO *event in _placesDataModel.events)
		{
			NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
			NSRange productNameRange = NSMakeRange(0, event.name.length);
			NSRange foundRange = [event.name rangeOfString:searchString options:searchOptions range:productNameRange];
			if (foundRange.length > 0)
			{
				[_aryPlacesSearched addObject:event];
			}
		}
		for (BSHighlightPlaceDataModel *place in _placesDataModel.places)
		{
			NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
			NSRange productNameRange = NSMakeRange(0, place.nameLocalized.length);
			NSRange foundRange = [place.nameLocalized rangeOfString:searchString options:searchOptions range:productNameRange];
			if (foundRange.length > 0)
			{
				[_aryPlacesSearched addObject:place];
			}
		}
    }
	
    return YES;
}

@end
