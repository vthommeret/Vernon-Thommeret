//
//  MembersTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Group;

/**
 A MembersTableViewCellController is responsible for creating and managing an
 SingleTableViewCell populated with the number of members in a group. When a
 user selects a cell, the controller creates a MemberDetailViewController,
 populates it with the group, and pushes it onto the navigation stack.
 */
@interface MembersTableViewCellController : AbstractTableViewCellController {
	Group *_group;
}

@property (nonatomic, retain) Group *group;

@end
