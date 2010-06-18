//
//  LocationDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "Location.h"
#import "Annotation.h"

@implementation LocationDetailViewController

@synthesize mapView;
@synthesize location;

- (id) initWithLocation:(Location *)_location {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.location = _location;
	}
	
	return self;
}

- (void)dealloc {
	[mapView release];
	[location release];
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
	mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	self.view = mapView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Map";
	
	UIBarButtonItem *googleMapsButton = [[UIBarButtonItem alloc] initWithTitle:@"Google Maps"
																		 style:UIBarButtonItemStyleBordered target:self action:@selector(launchGoogleMaps)];
	self.navigationItem.rightBarButtonItem = googleMapsButton;
	[googleMapsButton release];
	
	// set up map region
	
	CLLocationCoordinate2D coord;
	coord.latitude = location.lat;
	coord.longitude = location.lon;
	
	MKCoordinateRegion region;
	region.center = coord;
	region.span.latitudeDelta = 0.01;
	region.span.longitudeDelta = 0.01;
	
	mapView.region = region;
	
	mapView.delegate = self;
	self.navigationController.delegate = self;
}

#pragma mark -
#pragma mark Launch Google Maps

- (void) launchGoogleMaps {
	NSString *mapQuery = [[location mapDescription]
						  stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSString *mapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", mapQuery];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapUrl]];
}

#pragma mark -
#pragma mark Navigation Controller Delegate Methods

- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	Annotation *annotation = [[Annotation alloc] initWithCoordinate:mapView.region.center];
	annotation.title = [location shortDescription];
	[mapView addAnnotation:annotation];
	[annotation release];
	
	mapView.delegate = nil;
	navigationController.delegate = nil;
}

#pragma mark -
#pragma mark Map View Delegate Methods

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
	MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
	
	if (pin == nil) {
		pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"] autorelease];
	} else {
		pin.annotation = annotation;
	}
	
	pin.canShowCallout = YES;
	pin.pinColor = MKPinAnnotationColorRed;
	pin.animatesDrop = YES;
	
	return pin;
}

@end
