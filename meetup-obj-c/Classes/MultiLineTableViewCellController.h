//
//  MultiLineTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

/**
 A MultiLineTableViewCellController is responsible for creating and managing a
 MultiLineTableViewCell. When a user selects a cell, the controller creates
 a TextDetailViewController, populates it with the text, and pushes it onto the
 navigation stack.
 */
@interface MultiLineTableViewCellController : AbstractTableViewCellController {
	NSString *_content;
	BOOL _showFull;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL showFull;

@end
