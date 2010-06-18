//
//  Event.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/29/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rsvp.h"

@class Location;

@interface Event : NSObject {
	NSInteger _eventId;
	NSString *_name;
	NSString *_description;
	Location *_location;
	NSDate *_date;
	NSInteger _rsvpCount;
	NSInteger _maybeRsvpCount;
	NSInteger _noRsvpCount;
	NSString *_photoUrl;
	RsvpResponse _myRsvp;
}

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSInteger rsvpCount;
@property (nonatomic, assign) NSInteger maybeRsvpCount;
@property (nonatomic, assign) NSInteger noRsvpCount;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, assign) RsvpResponse myRsvp;

- (id)initWithResponseObject:(NSDictionary *)response;

@end
