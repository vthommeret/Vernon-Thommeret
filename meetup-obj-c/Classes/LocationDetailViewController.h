//
//  LocationDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Location;

/**
 A LocationDetailViewController is responsible for displaying a location visually as a map.
 */
@interface LocationDetailViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate> {
	MKMapView *mapView;
	Location *location;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) Location *location;

- (id) initWithLocation:(Location *)_location;

@end
