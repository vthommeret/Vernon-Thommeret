//
//  Comment.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Comment : NSObject {
	User *_user;
	NSString *_text;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, copy) NSString *text;

- (id)initWithResponseObject:(NSDictionary *)response;

@end
