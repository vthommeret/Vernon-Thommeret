//
//  Group.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/21/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Group.h"

@implementation Group

@synthesize groupId = _groupId;
@synthesize name = _name;
@synthesize description = _description;
@synthesize photoUrl = _photoUrl;
@synthesize created = _created;
@synthesize members = _members;
@synthesize who = _who;
@synthesize location = _location;
@synthesize rating = _rating;
@synthesize reviewCount = _reviewCount;
@synthesize photoCount = _photoCount;

- (void) dealloc {
	[_name release];
	[_description release];
	[_photoUrl release];
	[_created release];
	[_who release];
	[_location release];
	[super dealloc];
}

- (id)initWithResponseObject:(NSDictionary *)response {
	if (self = [super init]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = kDatabaseDate;
		
		// basic properties
		self.groupId = [[response objectForKey:@"id"] intValue];
		self.name = [response objectForKey:@"name"];
		self.description = [response objectForKey:@"description"];
		self.photoUrl = [response objectForKey:@"photo_url"];
		self.created = [dateFormatter dateFromString:[response objectForKey:@"created"]];
		self.members = [[response objectForKey:@"members"] intValue];
		self.rating = [[response objectForKey:@"rating"] floatValue] / 5.0;
		self.reviewCount = [[response objectForKey:@"review_count"] intValue];
		self.photoCount = [[response objectForKey:@"group_photo_count"] intValue];
		
		// what members call themselves
		NSString *who = [response objectForKey:@"who"];
		self.who = who != nil ? who : @"members";
		
		// group location
		Location *location = [[Location alloc] init];
		location.city = [response objectForKey:@"city"];
		location.state = [response objectForKey:@"state"];
		location.zip = [response objectForKey:@"zip"];
		location.lat = [[response objectForKey:@"lat"] doubleValue];
		location.lon = [[response objectForKey:@"lon"] doubleValue];
		self.location = location;
		[location release];
		
		[dateFormatter release];
	}
	return self;
}

- (NSString *)membersDescription {
	NSString *who = self.who;
	
	if ([who length] == 0) {
		who = @"Members";
	}
	
	return [NSString stringWithFormat:@"%d %@", self.members, who];
}

@end
