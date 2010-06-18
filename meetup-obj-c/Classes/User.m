//
//  User.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/23/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "User.h"
#import "Location.h"

@implementation User

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize bio = _bio;
@synthesize photoUrl = _photoUrl;
@synthesize location = _location;

- (void)dealloc {
	[_name release];
	[_bio release];
	[_photoUrl release];
	[_location release];
	[super dealloc];
}

- (id)initWithResponseObject:(NSDictionary *)response {
	if (self = [super init]) {
		self.userId = [[response objectForKey:@"id"] intValue];
		self.name = [response objectForKey:@"name"];
		self.bio = [response objectForKey:@"bio"];
		self.photoUrl = [response objectForKey:@"photo_url"];

		// group location
		Location *location = [[Location alloc] init];
		location.city = [response objectForKey:@"city"];
		location.state = [response objectForKey:@"state"];
		location.country = [response objectForKey:@"country"];
		location.zip = [response objectForKey:@"zip"];
		location.lat = [[response objectForKey:@"lat"] doubleValue];
		location.lon = [[response objectForKey:@"lon"] doubleValue];
		self.location = location;
		[location release];
	}
	return self;
}

@end
