//
//  HomeRootViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "HomeRootViewController.h"
#import "YourEventsTableViewController.h"
#import "NearbyEventsTableViewController.h"

#define kYourMeetups	0
#define kNearbyMeetups	1

@implementation HomeRootViewController

@synthesize yourEventsController = _yourEventsController;
@synthesize nearbyEventsController = _nearbyEventsController;
@synthesize segControl = _segControl;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// set up segmented control
	
	UISegmentedControl *segControl = [[UISegmentedControl alloc]
									  initWithItems:[NSArray arrayWithObjects:@"Your Meetups", @"Nearby Meetups", nil]];
	
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segControl setSelectedSegmentIndex:0];
	[segControl addTarget:self action:@selector(eventFilterDidChange:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segControl;
	
	self.segControl = segControl;
	[segControl release];
	
	// set up table view controller
	
	YourEventsTableViewController *yourEventsController = [[YourEventsTableViewController alloc]
												 initWithStyle:UITableViewStylePlain];
	yourEventsController.parentController = self;
	[self.view addSubview:yourEventsController.view];
	
	self.yourEventsController = yourEventsController;
	[yourEventsController release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.segControl.selectedSegmentIndex == kYourMeetups) {
		[self.yourEventsController viewWillAppear:animated];
	} else { // segControl.selectedSegmentIndex == kNearbyMeetups
		[self.nearbyEventsController viewWillAppear:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.segControl.selectedSegmentIndex == kYourMeetups) {
		[self.yourEventsController viewDidAppear:animated];
	} else { // segControl.selectedSegmentIndex == kNearbyMeetups
		[self.nearbyEventsController viewDidAppear:animated];
	}
}

- (void)eventFilterDidChange:(id)sender {	
	if (self.segControl.selectedSegmentIndex == kYourMeetups) {
		[self.view bringSubviewToFront:self.yourEventsController.view];
		[self.yourEventsController viewDidAppear:NO];
		
		self.yourEventsController.tableView.scrollsToTop = YES;
		self.nearbyEventsController.tableView.scrollsToTop = NO;
	} else { // segControl.selectedSegmentIndex == kNearbyMeetups
		if (self.nearbyEventsController == nil) {
			NearbyEventsTableViewController *nearbyEventsController = [[NearbyEventsTableViewController alloc]
																	   initWithStyle:UITableViewStylePlain];
			nearbyEventsController.parentController = self;
			[self.view addSubview:nearbyEventsController.view];
			[nearbyEventsController viewDidAppear:NO];
			
			self.nearbyEventsController = nearbyEventsController;
			[nearbyEventsController release];
		} else {
			[self.view bringSubviewToFront:self.nearbyEventsController.view];
			[self.nearbyEventsController viewDidAppear:NO];
		}
		
		self.nearbyEventsController.tableView.scrollsToTop = YES;
		self.yourEventsController.tableView.scrollsToTop = NO;
	}
}

- (void)dealloc {
	[_yourEventsController release];
	[_nearbyEventsController release];
	[_segControl release];
    [super dealloc];
}


@end
