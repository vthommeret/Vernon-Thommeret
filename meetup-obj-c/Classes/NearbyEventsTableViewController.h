//
//  NearbyEventsTableViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AbstractTableViewController.h"

@class MeetupAsyncRequest;
@class StatusView;

@interface NearbyEventsTableViewController : AbstractTableViewController <CLLocationManagerDelegate> {
	NSMutableArray *_nearbyEventControllers;
	MeetupAsyncRequest *_nearbyEventsRequest;
	CLLocationManager *_locationManager;
	BOOL _didReceiveLocation;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *nearbyEventControllers;
@property (nonatomic, retain) MeetupAsyncRequest *nearbyEventsRequest;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL didReceiveLocation;
@property (nonatomic, retain) StatusView *statusView;

@end
