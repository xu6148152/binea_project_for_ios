//
//  BSTeamLocationViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamLocationViewController.h"
#import "BSAuthorizationViewController.h"

#import "BSMapAnnotation.h"
#import "BSQueryNearbyPlacesHttpRequest.h"
#import "BSTeamLocationSearchViewController.h"

#import <MapKit/MapKit.h>
#import "INTULocationManager.h"

#define kCityMeters 5000
#define kGeocodingDelay 2
#define kDistanceThreshold 100

typedef NS_ENUM(int, BSLocationState) {
	BSLocationStateInit,
	BSLocationStateMapLoaded,
	BSLocationStateFirstLocated,
	BSLocationStateManual
};

@interface BSTeamLocationViewController () <MKMapViewDelegate, BSTeamLocationSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locateMeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;

@property BSLocationState state;
@property CLLocation *geoCodingLocation;

@end

@implementation BSTeamLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (self.mapAnnotation) {
		self.state = BSLocationStateManual;
		//[self.mapView addAnnotation:self.mapAnnotation];
		[self.searchButton setTitle:self.mapAnnotation.title forState:UIControlStateNormal];
		
		ZPLogTrace(@"setRegion by team location");
		CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mapAnnotation.coordinate.latitude longitude:self.mapAnnotation.coordinate.longitude];
		[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, kCityMeters, kCityMeters) animated:NO];
	} else {
		[[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
			if (status == INTULocationStatusSuccess) {
				if (!self.mapAnnotation && self.state < BSLocationStateManual) {
					self.state = BSLocationStateFirstLocated;
					ZPLogTrace(@"setRegion by first locate");
					[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, kCityMeters, kCityMeters) animated:NO];
				}
			}
		}];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
		BSAuthorizationViewController *vc = [BSAuthorizationViewController instanceFromDefaultNibWithType:BSAuthorizationTypeLocation];
		[vc showInViewController:self dismissCompletion:nil];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) _setAndShowMapAnnotation:(CLLocation *)location animated:(BOOL)animated {
	ZPLogTrace(@"_setAndShowMapAnnotation at (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
	if (!self.mapAnnotation) {
		self.mapAnnotation = [[BSMapAnnotation alloc] initWithCoordinate:location.coordinate];
		//[self.mapView addAnnotation:self.mapAnnotation];
	} else {
		BOOL noGeocode = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:self.mapAnnotation.coordinate.latitude longitude:self.mapAnnotation.coordinate.longitude]] < kDistanceThreshold;
		
		[UIView animateWithDuration:animated ? kDefaultAnimateDuration : 0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.mapAnnotation.coordinate = location.coordinate;
		} completion:nil];
		
		if (noGeocode) {
			return;
		}
	}
	
	self.mapAnnotation.title = nil;
	[self.searchButton setTitle:ZPLocalizedString(@"Updating Location...") forState:UIControlStateNormal];
	self.okButton.enabled = NO;
	[self reverseGeocodeLocation:location];
}

- (void) reverseGeocodeLocation:(CLLocation *)location {
	self.geoCodingLocation = location;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kGeocodingDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (self.geoCodingLocation != location) {
			return;
		}
		
		ZPLogTrace(@"reverseGeocodeLocation (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
		BSQueryNearbyPlacesHttpRequest *request = [BSQueryNearbyPlacesHttpRequest requestWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			NSArray *places = ((BSHighlightPlacesDataModel *)result.dataModel).places;

			for (BSHighlightPlaceDataModel *place in places) {
				if (place.nameLocalized) {
					self.mapAnnotation.title = place.nameLocalized;
					[self.searchButton setTitle:place.nameLocalized forState:UIControlStateNormal];
					self.okButton.enabled = YES;
					return;
				}
			}

		} failedBlock:nil];
	});
}

- (IBAction)locateMe:(id)sender {
	if (self.mapView.userLocation && self.mapView.userLocation.location) {
		ZPLogTrace(@"setRegion by locate me");
		[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, kCityMeters, kCityMeters) animated:YES];
	}
}

- (IBAction)okBtnTapped:(id)sender {
	if (self.delegate) {
		[self.delegate didSelectMapAnnotation:self.mapAnnotation];
	}
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"BSLocationSearchSegue"]) {
		BSTeamLocationSearchViewController *vc = (BSTeamLocationSearchViewController *)segue.destinationViewController;
		vc.delegate = self;
	}
}

#pragma mark - BSTeamLocationSearchViewControllerDelegate
- (void) didSelectLocationName:(NSString *)locationName latitude:(float)latitude longitude:(float)longitude {
	if (!self.mapAnnotation) {
		self.mapAnnotation = [[BSMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
		[self.mapView addAnnotation:self.mapAnnotation];
	} else {
		self.mapAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
	}
	self.mapAnnotation.title = locationName;
	[self.searchButton setTitle:locationName forState:UIControlStateNormal];
	self.okButton.enabled = YES;
	[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapAnnotation.coordinate, kCityMeters, kCityMeters) animated:YES];
}

#pragma mark - MKMapViewDelegate
- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	if (self.state == BSLocationStateInit) {
		self.state = BSLocationStateMapLoaded;
	} else {
		[self _setAndShowMapAnnotation:[[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude] animated:YES];
	}
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	if (self.state < BSLocationStateManual && userLocation && userLocation.location) {
		self.state = BSLocationStateManual;
		
		ZPLogTrace(@"setRegion by map locate");
		[mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, kCityMeters, kCityMeters) animated:YES];
	}
}
@end
