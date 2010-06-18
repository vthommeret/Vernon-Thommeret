//
//  User.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/23/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@interface User : NSObject {
	NSInteger _userId;
	NSString *_name;
	NSString *_bio;
	NSString *_photoUrl;
	Location *_location;
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, retain) Location *location;

- (id)initWithResponseObject:(NSDictionary *)response;

@end
