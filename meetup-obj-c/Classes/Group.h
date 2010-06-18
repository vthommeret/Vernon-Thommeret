//
//  Group.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/21/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Group : NSObject {
	NSInteger _groupId;
	NSString *_name;
	NSString *_description;
	NSString *_photoUrl;
	NSDate *_created;
	NSInteger _members;
	NSString *_who;
	Location *_location;
	CGFloat _rating;
	NSInteger _reviewCount;
	NSInteger _photoCount;
}

@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, assign) NSInteger members;
@property (nonatomic, copy) NSString *who;
@property (nonatomic, retain) Location *location;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, assign) NSInteger reviewCount;
@property (nonatomic, assign) NSInteger photoCount;

- (id)initWithResponseObject:(NSDictionary *)response;
- (NSString *)membersDescription;

@end
