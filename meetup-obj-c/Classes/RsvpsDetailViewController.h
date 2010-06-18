//
//  RsvpsDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class Event;
@class MeetupAsyncRequest;
@class StatusView;

/**
 An RsvpsDetailViewController is responsible for displaying the rsvps of an event.
 */
@interface RsvpsDetailViewController : AbstractTableViewController {
	NSMutableArray *_rsvpControllers;
	Event *_event;
	MeetupAsyncRequest *_rsvpsRequest;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *rsvpControllers;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) MeetupAsyncRequest *rsvpsRequest;
@property (nonatomic, retain) StatusView *statusView;

@end
