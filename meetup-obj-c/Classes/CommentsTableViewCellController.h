//
//  CommentsTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Group;

/**
 A CommentsTableViewCellController is responsible for creating and managing an
 SingleTableViewCell populated with the number of comments for a group. When a
 user selects a cell, the controller creates a CommentsDetailViewController,
 populates it with the group, and pushes it onto the navigation stack.
 */
@interface CommentsTableViewCellController : AbstractTableViewCellController {
	Group *_group;
	BOOL _more;
}

@property (nonatomic, retain) Group *group;
@property (nonatomic, assign) BOOL more;

@end
