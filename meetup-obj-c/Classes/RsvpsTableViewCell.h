//
//  RsvpTableViewCell.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"

@class Event;

/**
 An RsvpTableViewCell is responsible for displaying a the Rsvp information
 for an event.
 */
@interface RsvpsTableViewCell : AbstractTableViewCell {
	Event *_event;
}

@property (nonatomic, retain) Event *event;

@end

#pragma mark -
#pragma mark RsvpsTableViewCellView interface

@interface RsvpTableViewCellView : AbstractTableViewCellView {}

@end
