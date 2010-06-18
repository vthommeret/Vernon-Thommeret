//
//  RsvpsTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Event;

/**
 An RsvpsTableViewCellController uses an RsvpsTableViewCell to visually show the number of "Yes," Maybe," and "No" rsvps
 to an event. When a user selects a cell, the controller creates an RsvpsDetailViewController, populates it with the event,
 and pushes it onto the navigation stack.
 */
@interface RsvpsTableViewCellController : AbstractTableViewCellController {
	Event *_event;
}

@property (nonatomic, retain) Event *event;

@end
