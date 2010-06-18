//
//  Annotation.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/22/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	if (self = [super init]) {
		self.coordinate = coordinate;
	}
	
	return self;
}

- (void) dealloc {
	[_title release];
	[_subtitle release];
	[super dealloc];
}

@end
