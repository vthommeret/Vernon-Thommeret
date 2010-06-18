//
//  Comment.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

@synthesize user = _user;
@synthesize text = _text;

- (void)dealloc {
	[_user release];
	[_text release];
	[super dealloc];
}

- (id)initWithResponseObject:(NSDictionary *)response {
	if (self = [super init]) {
		self.text = [response objectForKey:@"comment"];
		
		User *user = [[User	alloc] init];
		user.name = [response objectForKey:@"name"];
		self.user = user;
		[user release];
	}
	return self;
}

@end
