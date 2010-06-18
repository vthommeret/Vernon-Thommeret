//
//  RootTableViewCellController.h
//  Tabletest
//
//  Created by Vernon Thommeret on 7/30/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@class Group;

/**
 A GroupTableViewCellController is responsible for creating and managing a
 GroupTableViewCell. When a user selects a cell, the controller creates
 a GroupDetailViewController, populates it with the group, and pushes it onto the
 navigation stack.
 */
@interface GroupTableViewCellController : AbstractTableViewCellController {
	Group *_group;
}

@property (nonatomic, retain) Group *group;

@end
