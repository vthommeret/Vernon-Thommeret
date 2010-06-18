//
//  EventTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Event;

/**
 An EventTableViewCellController is responsible for creating and managing an
 EventTableViewCell. When a user selects a cell, the controller creates
 an EventDetailViewController, populates it with the event, and pushes it onto the
 navigation stack.
 */
@interface EventTableViewCellController : AbstractTableViewCellController {
	Event *_event;
}

@property (nonatomic, retain) Event *event;

@end
