//
//  RsvpTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Rsvp;

/**
 An RsvpTableViewCellController is responsible for creating and managing a
 PhotoTableViewCell. When a user selects a cell, the controller creates
 a UserDetailViewController, populates it with the user, and pushes it onto the
 navigation stack.
 */
@interface RsvpTableViewCellController : AbstractTableViewCellController {
	Rsvp *_rsvp;
}

@property (nonatomic, retain) Rsvp *rsvp;

@end
