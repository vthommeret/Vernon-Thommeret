//
//  RsvpControlTableViewCell.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/25/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"

@class Event, RsvpControlItemView;

/**
 An RsvpControlTableViewCell is responsible for displaying a the Rsvp information
 for an event.
 */
@interface RsvpControlTableViewCell : AbstractTableViewCell {
	Event *_event;
	RsvpControlItemView *_yes;
	RsvpControlItemView *_maybe;
	RsvpControlItemView *_no;
	RsvpControlItemView *_selected;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) RsvpControlItemView *yes;
@property (nonatomic, retain) RsvpControlItemView *maybe;
@property (nonatomic, retain) RsvpControlItemView *no;
@property (nonatomic, retain) RsvpControlItemView *selected;

@end

#pragma mark -
#pragma mark RsvpControlItemView interface

@interface RsvpControlItemView : UIView {
	UIImage *_normal;
	UIImage *_down;
	UIImage *_selected;
	NSString *_text;
	UIControlState _state;
	id _delegate;
}

@property (nonatomic, retain) UIImage *normal;
@property (nonatomic, retain) UIImage *down;
@property (nonatomic, retain) UIImage *selected;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIControlState state;
@property (nonatomic, assign) id delegate;

- (id)initWithImage:(NSString *)image text:(NSString *)text origin:(CGPoint)origin;
- (void)deselect;

@end