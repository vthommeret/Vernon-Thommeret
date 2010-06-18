//
//  TextDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

/**
 A TextDetailViewController is a simple view controller that essentially is
 an AbstractTableViewController with one row — A MultiLineTableViewCellController
 configured to show the full text. This view controller is useful for displaying
 extended, static text like descriptions and instructions.
 */
@interface TextDetailViewController : AbstractTableViewController {
	NSString *_text;
}

@property (nonatomic, copy) NSString *text;

@end
