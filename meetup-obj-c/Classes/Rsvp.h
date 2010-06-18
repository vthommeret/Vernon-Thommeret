//
//  Rsvp.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	RsvpResponseNone,
    RsvpResponseYes,
	RsvpResponseMaybe,
    RsvpResponseNo
} RsvpResponse;

@class User;
@class Event;

@interface Rsvp : NSObject {
	User *_user;
	Event *_event;
	RsvpResponse _response;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Event *event;
@property (nonatomic, assign) RsvpResponse response;

- (id)initWithResponseObject:(NSDictionary *)response;

@end
