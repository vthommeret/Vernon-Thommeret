//
//  EventTableViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "DetailHeaderView.h"

@class Event, DetailHeaderViewButton, MeetupAsyncRequest;

/**
 An EventDetailViewController is one of the main view controllers, responsible for
 displaying everything applicable to an event — its basic information, its description,
 a reference to its group, the location of the event, contact information, rsvp information,
 comments, and photos if available.
 */
@interface EventDetailViewController : AbstractTableViewController <DetailHeaderViewDelegate, UIActionSheetDelegate> {
	Event *_event;
	DetailHeaderViewButton *_rsvpButton;
	DetailHeaderViewButton *_rsvpInfoButton;
	MeetupAsyncRequest *_updateRsvpRequest;
	
	NSString *_rsvp;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) DetailHeaderViewButton *rsvpButton;
@property (nonatomic, retain) DetailHeaderViewButton *rsvpInfoButton;
@property (nonatomic, retain) MeetupAsyncRequest *updateRsvpRequest;
@property (nonatomic, copy) NSString *rsvp;

- (void)doUpdateRsvpRequestWithRsvp:(NSString *)rsvp;

@end
