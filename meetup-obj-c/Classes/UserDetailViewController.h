//
//  UserDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "DetailHeaderView.h"

@class User, Group, MeetupAsyncRequest;

/**
 A UserDetailViewController is responsible for displaying a user's profile. If a group
 is provided, we'll also show their greetings, if available.
 */
@interface UserDetailViewController : AbstractTableViewController <DetailHeaderViewDelegate> {
	User *_user;
	Group *_group;
	NSMutableArray *_commentControllers;
	MeetupAsyncRequest *_greetingsRequest;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSMutableArray *commentControllers;
@property (nonatomic, retain) MeetupAsyncRequest *greetingsRequest;

@end
