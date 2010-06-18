//
//  LocationTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Location;

/**
 A LocationTableViewCellController is responsible for creating and managing
 a Location. When a user selects a cell, the controller creates a
 LocationDetailViewController, populates it with the location, and pushes it onto the
 navigation stack.
 */
@interface LocationTableViewCellController : AbstractTableViewCellController {
	Location *_location;
}

@property (nonatomic, retain) Location *location;

@end
