//
//  HomeRootViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YourEventsTableViewController;
@class NearbyEventsTableViewController;

@interface HomeRootViewController : UIViewController {
	YourEventsTableViewController *_yourEventsController;
	NearbyEventsTableViewController *_nearbyEventsController;
	UISegmentedControl *_segControl;
}

@property (nonatomic, retain) YourEventsTableViewController *yourEventsController;
@property (nonatomic, retain) NearbyEventsTableViewController *nearbyEventsController;
@property (nonatomic, retain) UISegmentedControl *segControl;

@end
