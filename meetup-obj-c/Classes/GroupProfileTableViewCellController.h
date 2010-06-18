//
//  GroupProfileTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class User;
@class Group;

/**
 A GroupProfileTableViewCellController is like a UserTableViewCellController in that
 it creates UserDetailViewController. A group profile, however, also has a group in addition
 to a user. This lets the user detail view controller shows stats like greetings and group
 profile questions.
 */
@interface GroupProfileTableViewCellController : AbstractTableViewCellController {
	User *_user;
	Group *_group;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Group *group;

@end
