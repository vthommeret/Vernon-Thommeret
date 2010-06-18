//
//  PhotosTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Group;

/**
 A PhotosTableViewCellController is responsible for creating and managing an
 SingleTableViewCell populated with the number of photos for a group. When a
 user selects a cell, the controller creates a CommentsDetailViewController,
 populates it with the group, and pushes it onto the navigation stack.
 */
@interface PhotosTableViewCellController : AbstractTableViewCellController {
	Group *_group;
}

@property (nonatomic, retain) Group *group;

@end
