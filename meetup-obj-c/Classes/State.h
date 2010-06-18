//
//  State.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface State : NSObject {
	User *_user;
	UIColor *_meetupColor;
	UIColor *_grayBackgroundColor;
	UIColor *_rowBackgroundColor;
	UIColor *_darkTextColor;
	UIColor *_keyColor;
	NSOperationQueue *_sharedQueue;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UIColor *meetupColor;
@property (nonatomic, retain) UIColor *grayBackgroundColor;
@property (nonatomic, retain) UIColor *rowBackgroundColor;
@property (nonatomic, retain) UIColor *darkTextColor;
@property (nonatomic, retain) UIColor *keyColor;
@property (nonatomic, retain) NSOperationQueue *sharedQueue;

+ (State *) sharedState;

@end
