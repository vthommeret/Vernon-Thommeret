//
//  Event.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/29/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Event.h"
#import "Location.h"

@implementation Event

@synthesize eventId = _eventId;
@synthesize name = _name;
@synthesize description = _description;
@synthesize location = _location;
@synthesize date = _date;
@synthesize rsvpCount = _rsvpCount;
@synthesize maybeRsvpCount = _maybeRsvpCount;
@synthesize noRsvpCount = _noRsvpCount;
@synthesize photoUrl = _photoUrl;
@synthesize myRsvp = _myRsvp;

- (void) dealloc {
	[_name release];
	[_description release];
	[_location release];
	[_date release];
	[_photoUrl release];
	[super dealloc];
}

- (id)initWithResponseObject:(NSDictionary *)response {
	if (self = [super init]) {
		self.eventId = [[response objectForKey:@"id"] integerValue];
		self.name = [response objectForKey:@"name"];
		self.description = [response objectForKey:@"description"];
		self.rsvpCount = [[response objectForKey:@"rsvpcount"] integerValue];
		self.maybeRsvpCount = [[response objectForKey:@"maybe_rsvpcount"] integerValue];
		self.noRsvpCount = [[response objectForKey:@"no_rsvpcount"] integerValue];
		self.photoUrl = [response objectForKey:@"photo_url"];
		
		// date
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = kDatabaseDate;
		self.date = [dateFormatter dateFromString:[response objectForKey:@"time"]];
		[dateFormatter release];
		
		// location
		
		Location *location = [[Location alloc] init];
		location.title = [response objectForKey:@"venue_name"];
		location.address1 = [response objectForKey:@"venue_address1"];
		location.address2 = [response objectForKey:@"venue_address2"];
		location.address3 = [response objectForKey:@"venue_address3"];
		location.city = [response objectForKey:@"venue_city"];
		location.state = [response objectForKey:@"venue_state"];
		location.zip = [response objectForKey:@"venue_zip"];
		location.lat = [[response objectForKey:@"venue_lat"] doubleValue];
		location.lon = [[response objectForKey:@"venue_lon"] doubleValue];
		location.phone = [response objectForKey:@"venue_phone"];
		
		if ([location.description length] != 0) {
			self.location = location;
		}
		
		[location release];
		
		// my rsvp
		
		NSString *myRsvp = [response objectForKey:@"myrsvp"];
		
		if ([myRsvp isEqualToString:@"yes"]) {
			self.myRsvp = RsvpResponseYes;
		} else if ([myRsvp isEqualToString:@"maybe"]) {
			self.myRsvp = RsvpResponseMaybe;
		} else if ([myRsvp isEqualToString:@"no"]) {
			self.myRsvp = RsvpResponseNo;
		} else { // [myRsvp isEqualToString:@"none"]
			self.myRsvp = RsvpResponseNone;
		}
	}
	return self;
}

@end
