//
//  RootTableViewController.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "NearbyEventsTableViewController.h"
#import "EventTableViewCellController.h"
#import "MeetupAsyncRequest.h"
#import "StatusView.h"
#import "Event.h"
#import "State.h"

@implementation NearbyEventsTableViewController

@synthesize nearbyEventControllers = _nearbyEventControllers;
@synthesize nearbyEventsRequest = _nearbyEventsRequest;
@synthesize locationManager = _locationManager;
@synthesize didReceiveLocation = _didReceiveLocation;
@synthesize statusView = _statusView;

- (void)dealloc {
	[_nearbyEventControllers release];
	[_nearbyEventsRequest release];
	[_locationManager release];
	[_statusView release];
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// display status view
	
	StatusViewItem *locating = [[StatusViewItem alloc] initWithText:@"Locating You…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.view.frame
														 style:StatusViewStyleScreen
												statusViewItem:locating];
	[locating release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// start grabbing location
	
	if (self.locationManager == nil) {
		CLLocationManager *locationManager = [[CLLocationManager alloc] init];
		self.locationManager = locationManager;
		[locationManager release];
	}
	
	self.locationManager.delegate = self;
    self.locationManager.distanceFilter = .1;  // .1 km
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	[self.locationManager stopUpdatingLocation];
	
	if (!self.didReceiveLocation) {
		self.didReceiveLocation = YES;
		
		CLLocationDegrees lat = newLocation.coordinate.latitude;
		CLLocationDegrees lon = newLocation.coordinate.longitude;
		
		// update loading overlay
		
		StatusViewItem *findingGroups = [[StatusViewItem alloc] initWithText:@"Finding Meetups Nearby…"];
		self.statusView.statusViewItem = findingGroups;
		[findingGroups release];
		
		// request nearby events
		MeetupAsyncRequest *nearbyEventsRequest = [[MeetupAsyncRequest alloc] init];
		nearbyEventsRequest.delegate = self;
		nearbyEventsRequest.callback = @selector(didReceiveNearbyEvents:);
		nearbyEventsRequest.errorCallback = @selector(didFailWithError:);
		[nearbyEventsRequest doMethod:@"events"
						   withParams:[NSString stringWithFormat:@"lat=%f&lon=%f&radius=5&order=time&page=25", lat, lon]];
		
		self.nearbyEventsRequest = nearbyEventsRequest;
		[nearbyEventsRequest release];
	}
}

- (void)didFailWithError:(NSError *)error {
	[_nearbyEventsRequest release];
	_nearbyEventsRequest = nil;
	
	NSString *errorString;
	
	if (error) {
		errorString = [error localizedDescription];
	} else {
		errorString = @"Couldn't talk to the API";
	}
	
	StatusViewItem *connectionFailed = [[StatusViewItem alloc] initWithText:errorString
																	   icon:[UIImage imageNamed:@"error.png"]];
	self.statusView.statusViewItem = connectionFailed;
	[connectionFailed release];
}

- (void)didReceiveNearbyEvents:(NSDictionary *)response {
	[_nearbyEventsRequest release];
	_nearbyEventsRequest = nil;
	
	NSDictionary *nearbyEventsResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *nearbyEventControllers = [[NSMutableArray alloc] initWithCapacity:15];
	
	for (NSDictionary *eventResult in nearbyEventsResults) {		
		Event *event = [[Event alloc] initWithResponseObject:eventResult];
		
		EventTableViewCellController *eventCellController = [[EventTableViewCellController alloc] init];
		eventCellController.navigationController = self.parentController.navigationController;
		eventCellController.event = event;
		[event release];
		
		[nearbyEventControllers addObject:eventCellController];
		
		[eventCellController release];
	}
	
	self.nearbyEventControllers = nearbyEventControllers;
	[nearbyEventControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}

- (void)constructTableItems {
	NSMutableArray *tableItems = [[NSMutableArray alloc] initWithObjects:self.nearbyEventControllers, nil];
	self.tableItems = tableItems;
	[tableItems release];
	
	
	NSMutableArray *nearbyEventControllers = self.nearbyEventControllers;
	
	if (nearbyEventControllers != nil) {
		NSMutableArray *tableHeaders = [[NSMutableArray alloc] initWithCapacity:5];
		NSMutableArray *tableItems = [[NSMutableArray alloc] initWithCapacity:5];
		
		NSMutableArray *unscheduledEvents = [[NSMutableArray alloc] initWithCapacity:5];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:kShortDate];
		for (EventTableViewCellController *eventController in nearbyEventControllers) {
			NSString *dateString = [dateFormatter stringFromDate:eventController.event.date];

			if (dateString == nil) {
				[unscheduledEvents addObject:eventController];
			} else {
				if ([dateString isEqual:[dateFormatter stringFromDate:[NSDate date]]]) {
					dateString = [NSString stringWithFormat:@"Today, %@", dateString];
				}
				
				if (![[tableHeaders lastObject] isEqual:dateString]) {
					[tableHeaders addObject:dateString];
					
					NSMutableArray *dayEvents = [[NSMutableArray alloc] initWithObjects:eventController, nil];
					[tableItems addObject:dayEvents];
					[dayEvents release];
				} else {
					[[tableItems lastObject] addObject:eventController];
				}
			}
		}
		[dateFormatter release];
		
		if ([unscheduledEvents count] != 0) {
			[tableHeaders addObject:@"Unscheduled"];
			[tableItems addObject:unscheduledEvents];
		}
		[unscheduledEvents release];
		
		self.tableHeaders = tableHeaders;
		self.tableItems = tableItems;
		
		[tableHeaders release];
		[tableItems release];
	}
}

@end
