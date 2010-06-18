//
//  State.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//
//	For a description of this implementation, see "Creating a Singleton Instance"
//	in The Cocoa Fundamentals Guide
//
//  Also, use your discretion. Properties held in State should be reserved strictly for objects
//  that you want to keep around for the lifetime of the project.

#import "State.h"

@implementation State

@synthesize user = _user;
@synthesize meetupColor = _meetupColor;
@synthesize grayBackgroundColor = _grayBackgroundColor;
@synthesize rowBackgroundColor = _rowBackgroundColor;
@synthesize darkTextColor = _darkTextColor;
@synthesize keyColor = _keyColor;
@synthesize sharedQueue = _sharedQueue;

static State *sharedState = nil;

+ (State *) sharedState {
    @synchronized (self) {
        if (sharedState == nil)
            [[self alloc] init]; // assignment not done here
    }
    return sharedState;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (sharedState == nil) {
            sharedState = [super allocWithZone:zone];
            return sharedState;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void) release {
    //do nothing
}

- (id) autorelease {
    return self;
}

@end
