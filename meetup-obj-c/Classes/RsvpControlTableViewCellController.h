//
//  RsvpControlTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/25/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Event;

/**
 An RsvpControlTableViewCellController is responsible for showing an RsvpControlTableViewCell.
 This cell is rendered as a threeway segmented control with options to RSVP "Yes," "Maybe," or
 "No" to an event.
 */
@interface RsvpControlTableViewCellController : AbstractTableViewCellController {
	Event *_event;
}

@property (nonatomic, retain) Event *event;

@end
